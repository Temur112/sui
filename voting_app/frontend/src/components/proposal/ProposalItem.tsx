import { useSuiClientQuery } from "@mysten/dapp-kit"
import { FC, useState } from "react"
import { EcText } from "../Shared"
import { SuiObjectData } from "@mysten/sui/client"
import { Proposal } from "../../types"
import { VoteModal } from "./VoteModal"


type ProposalItemProps = {
    id:string
}



export const Proposal_item:FC<ProposalItemProps> = ({id}) => {

    const [isModalOpen, setIsModalOpen] = useState(false);



    const {data: dataResponse, isPending, error} = useSuiClientQuery(
        "getObject", {
            id,
            options: {
                showContent: true
            }
        }
    )

    if (isPending) return <EcText text="Loading"/>;
    if(error) return <EcText isError text="Error"/>;
    if (!dataResponse.data) return <EcText text="Not Found"/>;


    const proposal = parseProposal(dataResponse.data);

    if(!proposal) return <EcText text="Proposal Not Found"/>

    // const expiration = proposal.expriration;
    const expiration = 1;

    const isExpired = isUnixTimeExpired(expiration);

    console.log(isExpired);

    return (
        <>
            <div onClick={() => !isExpired && setIsModalOpen(true)} className={`${isExpired? "cursor-not-allowed border-gray-600":"hover:border-blue-400"} p-4 border rounded-lg bg-white dark:bg-gray-800 transition-colors`}>
            <p className={`${isExpired ? "text-gray-500": "text-gray-300"} text-xl font-semibold mb-2 break-words`}>Title: {proposal.title}</p>
            <p className={`${isExpired ? "text-gray-500": "text-gray-300"}`}>Description: {proposal.description}</p>
                <div className="flex items-center justify-between mt-4">
                    <div className="flex space-x-4">
                        <div className={` ${isExpired? "text-green-800" : "text-green-600"} flex items-center`}>
                            <span className="mr-1">
                                👍
                                {proposal.votedYesCount}
                            </span>
                        </div>
                        <div className={`${isExpired? "text-red-800":"text-red-600"} flex item-center`}>
                            <span className="mr-1">
                                👎
                                {proposal.votedNoCount}
                            </span>
                        </div>
                    </div>
                    <EcText text={timeFormatUnixTime(expiration)}/>
                    <p className={`${isExpired?"text-gray-800":"text-gray-600"}`}></p>
                </div>
            </div>
        
            <VoteModal 
                proposal={proposal} 
                isOpen={isModalOpen} 
                onClose={()=>{setIsModalOpen(false)}}
                onVote={(votedYes) => alert(votedYes)}
            />
        </>
    )
}


function parseProposal(data: SuiObjectData) : Proposal | null{
    if (data.content?.dataType !== "moveObject"){
        return null;
    }

    const {voted_yes_count, voted_no_count, expiration, ...rest} = data.content.fields as any;


    return {
        ...rest,
        votedYesCount: Number(voted_yes_count),
        votedNoCount: Number(voted_no_count),
        expriration: Number(expiration)
    }
}


function isUnixTimeExpired(unixTimeSeconds: number){
    return new Date(unixTimeSeconds * 1000) < new Date()
}



function timeFormatUnixTime(timestamp: number) {

    if (isUnixTimeExpired(timestamp)){
        return "Expired"
    }


    return new Date(timestamp * 1000).toLocaleDateString("en-US", {
        month: "short",
        day: "2-digit",
        year: "numeric",
        hour: "2-digit",
        minute: "2-digit",
        second: "2-digit"
    });
}

