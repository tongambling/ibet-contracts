import { Address, toNano } from '@ton/core';
import { MainContract } from '../wrappers/MainContract';
import { NetworkProvider } from '@ton/blueprint';

const contractAddress = Address.parse('kQBfVO3EVq31snrKv_xSrxY0nmjo91TS6Ajw_cqh_H_cEopK');

export async function run(provider: NetworkProvider) {
    const contract = provider.open(new MainContract(contractAddress));

    await contract.sendWithdrawal(
        provider.sender(),
        toNano('0.05'),
        toNano('0.07')
    );

    await provider.waitForLastTransaction();
}
