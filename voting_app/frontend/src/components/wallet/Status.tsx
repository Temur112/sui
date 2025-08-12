


import { useCurrentAccount } from "@mysten/dapp-kit"
import { OwnedObjects } from "../OwnedObjects"

export const WalletStatus = () => {

    const account = useCurrentAccount();
    return (
        <div className="my-4 p-4 border rounded-lg bg-gray-100 dark:bg-gray-800">
            <h2 className="mb-2 text-xl font-bold">Wallet Status</h2>
            {
                account ? (
                    <div className="flex flex-col space-y-2">
                        <div><p className="text-grey-700 dark:text-gray-300">Wallet connected </p></div>

                        <div>
                            <p className="text-grey-700 dark:text-gray-300">
                                <span className="font-bold">Address: {account.address}</span>
                            </p>
                        </div>
                    </div>
                ): (
                    <p className="text-red-500 dark:text-red-400">Wallet not connected</p>
                )
            }
            <OwnedObjects/>
        </div>
    )
}