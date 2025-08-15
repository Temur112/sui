import { useSuiClientQuery } from "@mysten/dapp-kit";
import { useNetworkVariable } from "../config/networkConfig";
import { SuiObjectData } from "@mysten/sui/client";
import { Proposal_item } from "../components/proposal/ProposalItem";
;



// console.log(TEST_NET_DASHBOARD_ID);

const ProposalView = () => {

    const dashboardId = useNetworkVariable("dashboardId");
    console.log(dashboardId);

    const {data:dataResponse, isPending, error} = useSuiClientQuery(
        "getObject", {
            id:dashboardId,
            options: {
                showContent: true
            }
        }
    )

    if (isPending) return <div className="text-center text-gray-800">Loading....</div>;
    if(error) return <div className="text-red-500">Error: {error.message}</div>;
    if (!dataResponse.data) return <div className="text-center text-gray-500">Not Found</div>;

    console.log("here is the content that are being passed", dataResponse.data);

    return (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-20">
            {getDashboardFields(dataResponse.data)?.proposal_ids.map( id =>
                <Proposal_item key={id} id={id} />
            )}
        </div>
    )
}




function getDashboardFields(data: SuiObjectData) {
    if(data.content?.dataType !== "moveObject") return null;
    return data.content.fields as {
        id: SuiID,
        proposal_ids: string[]
    }
}

export default ProposalView;