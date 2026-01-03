import {address, toNano} from '@ton/core';
import { MainContract } from "../wrappers/MainContract";
import { compile, NetworkProvider } from '@ton/blueprint';

export async function run(provider: NetworkProvider) {
    const ownerAddress = '0QD4mlGU1Wlgn_vCb4tyAEPrI7BC8aRfMu0XHLUFdKKe7tYf'

    const contract = provider.open(
        MainContract.createFromConfig(
            {
                number: Math.floor(Math.random() * 10000000),
                recentSender: provider.sender().address,
                ownerAddress: address(ownerAddress),
            },
            await compile('MainContract'),
        ),
    );

    await contract.sendDeploy(provider.sender(), toNano('0.05'));

    await provider.waitForDeploy(contract.address);
}
