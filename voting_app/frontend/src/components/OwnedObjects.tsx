import { useCurrentAccount, useSuiClientQuery } from "@mysten/dapp-kit";
import { SuiObject } from "./SuiObject";

export const OwnedObjects = () => {

    const account = useCurrentAccount();

    const {data:response, error, isPending} = useSuiClientQuery(
        "getOwnedObjects",
        {
            owner: account?.address as string,
            options: {
                showType: true,
                showOwner: true,
                showContent: true,
            }
        },{
            enabled: !!account
        }
    );

    if (!account) return "we can not retrieve the account";
    if (error) return <div className="text-red-500 dark:text-red-400">Error: {error.message}</div>;

    if (isPending || !response) return <div className="text-center text-gray-500 dark:text-gray-400">Loading...</div>


    return (
        <div className="flex flex-col space-y-4 my-4">
            {response.data.length === 0? (
                <p className="text-center text-gray-500 dark:text-gray-400">No objects found in connected wallet</p>
            ):(
                <h2 className="text-xl font-bold">Owned Objects</h2>
            )}
            <div>
                {response.data.map(objectRes => (
                    <SuiObject key={objectRes.data?.objectId} objectRes={objectRes}/>   
                ))}
            </div>
        </div>
    )
}