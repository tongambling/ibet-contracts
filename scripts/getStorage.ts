import { Address } from '@ton/core';
import { MainContract } from '../wrappers/MainContract';
import { NetworkProvider } from '@ton/blueprint';

const contractAddress = Address.parse('kQBfVO3EVq31snrKv_xSrxY0nmjo91TS6Ajw_cqh_H_cEopK');

export async function run(provider: NetworkProvider) {
    const contract = provider.open(new MainContract(contractAddress));

    const storage = await contract.getStorage();

    const isTestNet = provider.network() === 'testnet'

    console.log('Storage: ', {
        number: storage.number,
        recentSender: storage.recentSender.toString({ testOnly: isTestNet, bounceable: false }),
        ownerAddress: storage.ownerAddress.toString({ testOnly: isTestNet, bounceable: false }),
    });
}
