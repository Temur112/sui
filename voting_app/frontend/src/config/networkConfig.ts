import { createNetworkConfig } from "@mysten/dapp-kit";
import { getFullnodeUrl } from "@mysten/sui/client";
import { TEST_NET_DASHBOARD_ID, DEV_NET_DASHBOARD_ID, MAIN_NET_DASHBOARD_ID } from "../constants";

const {networkConfig, useNetworkVariable} = createNetworkConfig({
    devnet: {
        url: getFullnodeUrl("devnet"),
        variables: {
            dashboardId: TEST_NET_DASHBOARD_ID
        }
    },
    testnet: {
        url: getFullnodeUrl("testnet"),
        variables: {
            dashboardId: DEV_NET_DASHBOARD_ID
        }
    },
    mainnet: {
        url: getFullnodeUrl("mainnet"),
        variables: {
            dashboardId: MAIN_NET_DASHBOARD_ID
        }
    }
})


export {networkConfig, useNetworkVariable};