import "errors"

const MIN_TONS_FOR_STORAGE = ton("0.01")

struct Storage {
    counter: uint64
    latestSenderAddress: address
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

struct (0x000000001) Increment {
    incrementBy: uint32
}

struct (0x000000002) Deposit {}

struct (0x000000003) Withdrawal {
    amount: coins
}

type AllowedMessage = Increment | Deposit | Withdrawal

fun onInternalMessage(in: InMessage) {
    val msg = lazy AllowedMessage.fromSlice(in.body);

    match (msg) {
        Increment => {
            var storage = lazy Storage.load();
            storage.counter += msg.incrementBy;
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
                body: null
            });

            reply.send(SEND_MODE_PAY_FEES_SEPARATELY)
        }

        else => {
            throw ErrCode.InvalidOperation
        }
    }
}

get fun (): (int, address, address) {
    val storage = lazy Storage.load();

    return storage
}

get fun balance(): int {
    return contract.getOriginalBalance()
}
