import { Address, toNano } from '@ton/core';
import { FirstContract } from '../wrappers/FirstContract';
import { NetworkProvider } from '@ton/blueprint';

const contractAddress = Address.parse('kQAbjvpG7n_z3h7sbfuIgLEzBcqMUNTI2HbqS9W51fetARRr');

export async function run(provider: NetworkProvider) {
    const firstContract = provider.open(new FirstContract(contractAddress));
    await firstContract.sendReset(provider.sender(), { value: toNano('0.05') });
    await provider.waitForLastTransaction();
}
