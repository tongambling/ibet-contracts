import "errors"

const MIN_TONS_FOR_STORAGE = ton("0.01")

struct Storage {
    number: uint32
    recentSender: address
    ownerAddress: address
}

// load contract data from persistent storage
fun Storage.load() {
    return Storage.fromCell(contract.getData())
}

// save contract data to persistent storage
fun Storage.save(self) {
    contract.setData(self.toCell())
}

struct (0x00000001) Increment {
    incrementBy: uint32
}

struct (0x00000002) Deposit {}

struct (0x00000003) Withdrawal {
    amount: coins
}

type AllowedMessage = Increment | Deposit | Withdrawal

fun onInternalMessage(in: InMessage) {
    val msg = lazy AllowedMessage.fromSlice(in.body);

    match (msg) {
        Increment => {
            var storage = lazy Storage.load();
            storage.number += msg.incrementBy;
            storage.recentSender = in.senderAddress;
            storage.save();
        }

        Deposit => {}

        Withdrawal => {
            var storage = lazy Storage.load();

            if (in.senderAddress != storage.ownerAddress) {
                throw ErrCode.NotPermitedOperation
            }

            val balance = contract.getOriginalBalance();

            if (balance < msg.amount) {
                throw ErrCode.InsufficientBalance;
            }

            val reply = createMessage({
                bounce: BounceMode.NoBounce,
                value: min(msg.amount, balance - MIN_TONS_FOR_STORAGE),
                dest: in.senderAddress,
                body: createEmptyCell()
            });

            reply.send(SEND_MODE_PAY_FEES_SEPARATELY)
        }

        else => {
            throw ErrCode.InvalidOperation
        }
    }
}

get fun getStorage(): (int, address, address) {
    val storage = lazy Storage.load();

    return (
        storage.number,
        storage.recentSender,
        storage.ownerAddress
    )
}

get fun getBalance(): int {
    return contract.getOriginalBalance()
}
