import { useQuery } from "@tanstack/react-query";
import { WalletStatus } from "../components/wallet/Status";



const WalletView = () => {


    // const {isPending, isFetching, data, error} = useQuery({
    //     queryKey: ["someKey"],
    //     queryFn: async() => {
    //         const response = await fetch("https://api.github.com/repos/TanStack/query");
    //         return response.json();
    //     }
    // });


    // if (isPending) return <div>Loading...</div>;
    // if (error) return <div>Error: {error.message}</div>;

    return (
        <>
            <div className="mb-8">
                <h1 className="text-3xl">Wallet sinfo</h1>
            </div>
            <div>
                {/* <h1>{data.full_name}</h1>
                <p>{data.description}</p>
                {isFetching? <p>Fetching...</p> : ""} */}
                <WalletStatus />
            </div>    
        </>
    )
}

export default WalletView;
