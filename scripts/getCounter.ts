import { Address } from '@ton/core';
import { FirstContract } from '../wrappers/FirstContract';
import { NetworkProvider } from '@ton/blueprint';

const contractAddress = Address.parse('kQAbjvpG7n_z3h7sbfuIgLEzBcqMUNTI2HbqS9W51fetARRr');

export async function run(provider: NetworkProvider) {
    const firstContract = provider.open(new FirstContract(contractAddress));
    const counter = await firstContract.getCounter();
    console.log('Counter: ', counter);
}
