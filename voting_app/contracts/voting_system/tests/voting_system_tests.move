#[test_only]

module voting_system::voting_system_tests;
use voting_system::dashboard::{Self,AdminCap, Dashboard};
use sui::test_scenario;
use voting_system::proposal::{Self, Proposal, VoteProofNFT, ProposalStatus};


const EWrongVoteCount:u64 = 0;
const EWrongNftUrl:u64 = 1;



#[test]
fun test_create_proposal_with_admin_cap(){


    let user = @0xCA;

    let mut scenario = test_scenario::begin(user);


    {
        dashboard::issue_admin_cap(scenario.ctx());
    };

    scenario.next_tx(user);
    {


        let admin_cap = scenario.take_from_sender<AdminCap>();
        // proposal::create(&admin_cap,title, desc, 2000000000, scenario.ctx());
        new_proposal(&admin_cap, scenario.ctx());

        test_scenario::return_to_sender(&scenario, admin_cap);

    };

    scenario.next_tx(user);
    {
        let created_proposal = scenario.take_shared<proposal::Proposal>();

        assert!(created_proposal.title() == b"Hi".to_string());
        assert!(created_proposal.desc() == b"There".to_string());
        assert!(created_proposal.voted_yes_count() == 0);
        assert!(created_proposal.voted_no_count() == 0);
        assert!(created_proposal.expiration() == 2000000000);
        assert!(created_proposal.creator() == user);
        assert!(created_proposal.voters().is_empty());

        test_scenario::return_shared(created_proposal);
    };

    scenario.end();
}



#[test]
#[expected_failure(abort_code = test_scenario::EEmptyInventory)]
fun test_create_proposal_no_admin_cap(){

    let admin = @0xCB;

    let user = @0xCA;

    let mut scenario = test_scenario::begin(admin);


    {
        dashboard::issue_admin_cap(scenario.ctx());
    };

    scenario.next_tx(user);
    {

        let admin_cap = scenario.take_from_sender<AdminCap>();
        new_proposal(&admin_cap, scenario.ctx());

        test_scenario::return_to_sender(&scenario, admin_cap);

    };

    scenario.next_tx(user);
    {
        let created_proposal = scenario.take_shared<proposal::Proposal>();

        assert!(created_proposal.title() == b"Hi".to_string());
        assert!(created_proposal.desc() == b"There".to_string());
        assert!(created_proposal.voted_yes_count() == 0);
        assert!(created_proposal.voted_no_count() == 0);
        assert!(created_proposal.expiration() == 2000000000);
        assert!(created_proposal.creator() == user);
        assert!(created_proposal.voters().is_empty());

        test_scenario::return_shared(created_proposal);
    };

    scenario.end();
}


#[test]
fun test_register_proposal_as_admin(){
    let admin = @0xAD;

    let mut scenario = test_scenario::begin(admin);

    {
        let otw = dashboard::new_otw(scenario.ctx());
        dashboard::issue_admin_cap(scenario.ctx());
        dashboard::new(otw, scenario.ctx());
    };

    scenario.next_tx(admin);

    {
        let mut dashboard = scenario.take_shared<Dashboard>();
        let admin_cap = scenario.take_from_sender<AdminCap>();

        let proposal_id = new_proposal(&admin_cap, scenario.ctx());


        dashboard.register_proposal(&admin_cap, proposal_id);

        let proposal_ids = dashboard::proposal_ids(&dashboard);

        let proposal_exists = proposal_ids.contains(&proposal_id);

        assert!(proposal_exists);


        scenario.return_to_sender(admin_cap);

        test_scenario::return_shared(dashboard);
    };

    scenario.end();
}



fun new_proposal(admin_cap: &AdminCap, ctx: &mut TxContext): ID {
    let title = b"Hi".to_string();

    let desc = b"There".to_string();

    // let admin_cap = scenario.take_from_sender<AdminCap>();
    let proposal_id = proposal::create(admin_cap,title, desc, 2000000000, ctx);

    proposal_id
}



#[test]
fun test_voting(){
    let user1 = @0xB0B;
    let user2 = @0xA23;
    let admin = @0xA01;

    let mut scenario = test_scenario::begin(admin);
    {
        dashboard::issue_admin_cap(scenario.ctx());
    };

    scenario.next_tx(admin);
    {
        let admin_cap = scenario.take_from_sender<AdminCap>();
        new_proposal(&admin_cap, scenario.ctx());
        test_scenario::return_to_sender(&scenario, admin_cap);
    };

    scenario.next_tx(user1);
    {
        let mut proposal = scenario.take_shared<Proposal>();
        
        proposal.vote(true, scenario.ctx());

        assert!(proposal.voted_yes_count() == 1, EWrongVoteCount);


        test_scenario::return_shared(proposal);
    };


        scenario.next_tx(user2);
    {
        let mut proposal = scenario.take_shared<Proposal>();
        
        proposal.vote(true, scenario.ctx());


        assert!(proposal.voted_yes_count() == 2, EWrongVoteCount);
        assert!(proposal.voted_no_count() == 0, EWrongVoteCount);


        test_scenario::return_shared(proposal);
    };

    scenario.end();
}



#[test]
#[expected_failure(abort_code = voting_system::proposal::EDuplicateVote)]
fun test_error_duplcate_votingvoting(){
    let user1 = @0xB0B;
    let admin = @0xA01;

    let mut scenario = test_scenario::begin(admin);
    {
        dashboard::issue_admin_cap(scenario.ctx());
    };

    scenario.next_tx(admin);
    {
        let admin_cap = scenario.take_from_sender<AdminCap>();
        new_proposal(&admin_cap, scenario.ctx());
        test_scenario::return_to_sender(&scenario, admin_cap);
    };

    scenario.next_tx(user1);
    {
        let mut proposal = scenario.take_shared<Proposal>();
        
        proposal.vote(true, scenario.ctx());
        proposal.vote(true, scenario.ctx());


        test_scenario::return_shared(proposal);
    };

    scenario.end();
}


#[test]
fun test_issue_vote_proof(){
    let user1 = @0xB0B;
    let admin = @0xA01;

    let mut scenario = test_scenario::begin(admin);
    {
        dashboard::issue_admin_cap(scenario.ctx());
    };

    scenario.next_tx(admin);
    {
        let admin_cap = scenario.take_from_sender<AdminCap>();
        new_proposal(&admin_cap, scenario.ctx());
        test_scenario::return_to_sender(&scenario, admin_cap);
    };

    
    scenario.next_tx(user1);
    {
        let mut proposal = scenario.take_shared<Proposal>();
        
        proposal.vote(true, scenario.ctx());


        test_scenario::return_shared(proposal);
    };


    scenario.next_tx(user1);
    {
        let vote_proof = scenario.take_from_sender<VoteProofNFT>();

        assert!(vote_proof.vote_proof_nft().inner_url() == b"https://singforamoment.sirv.com/nft_yes.png".to_ascii_string(), EWrongNftUrl);
        
        test_scenario::return_to_sender(&scenario, vote_proof);
    };

    scenario.end();
}


#[test]
fun test_change_proposal_status(){
    let admin: = @0xA01;

    let mut scenario = test_scenario::begin(admin);
    {
        dashboard::issue_admin_cap(scenario.ctx());
    };

    scenario.next_tx(admin);
    {
        let admin_cap = scenario.take_from_sender<AdminCap>();
        new_proposal(&admin_cap, scenario.ctx());
        test_scenario::return_to_sender(&scenario, &admin_cap);
    };

    scenario.next_tx(admin);
    {
        let proposal = scenario.take_shared<Proposal>();

        assert!(proposal.status) == Proposal::Active;

    };

    scenario.end()
}