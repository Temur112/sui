import { SuiObjectResponse } from "@mysten/sui/client";
import { FC } from "react";


type SuiObjectProps = {
    objectRes: SuiObjectResponse
}



export const SuiObject:FC<SuiObjectProps> = ({objectRes}) => {


    const owner = objectRes.data?.owner;
    const objcetType = objectRes.data?.type;


    const isCoin = objcetType?.includes("0x2::coin::Coin");
    const balance = isCoin ? (objectRes.data?.content as any).fields?.balance : -1;


    
    return (
        <div>
            <div key={objectRes.data?.objectId} className="p-2 border rounded-lg bg-gray-100 dark:bg-gray-800">
                    <p className="text-gray-700 dark:text-gray-300">
                        Object ID: {objectRes.data?.objectId}
                    </p>
                    <p className="text-gray-700 dark:text-gray-300">
                        Type: {objectRes.data?.type}
                    </p>
                    <p className="text-gray-700 dark:text-gray-300">
                        Owner: {
                            typeof owner === "object" && owner != null && "AddressOwner" in owner ? owner.AddressOwner : "ObjectOwner"
                        }
                    </p>
                    <p className="text-gray-700 dark:text-gray-300">
                        Balance: {isCoin ? balance : "N/A"}
                    </p>
                </div>
        </div>
    )
}