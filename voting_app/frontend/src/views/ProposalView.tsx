

const PROPOSAL_COUNT = 10;


const Proposal_item = () => {
    return (
        <div className="p-4 border rounded-lg bg-white dark:bg-gray-800 hover:border-blue-400 transition-colors">
            <div className="text-xl font-semibold mb-2">Title: here is the titke of the proposal</div>
            <div className="text-gray-600 dark:text-gray-400">Description: here is the description of the proposal</div>

        </div>
    )
}


const ProposalView = () => {
    return (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-20">
            {
                new Array(PROPOSAL_COUNT).fill(1).map((id) => 
                     <Proposal_item  key={id*Math.random()}/>
                )
            }
        </div>
    )
}


export default ProposalView;