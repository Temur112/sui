#[test_only]

module voting_system::voting_system_tests;
use voting_system::dashboard::{Self,AdminCap};
use sui::test_scenario;
use voting_system::proposal::{Self};



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
        assert!(created_proposal.voter_registry().is_empty());

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
        assert!(created_proposal.voter_registry().is_empty());

        test_scenario::return_shared(created_proposal);
    };

    scenario.end();
}


fun new_proposal(admin_cap: &AdminCap, ctx: &mut TxContext) {
    let title = b"Hi".to_string();

    let desc = b"There".to_string();

    // let admin_cap = scenario.take_from_sender<AdminCap>();
    proposal::create(admin_cap,title, desc, 2000000000, ctx);
}