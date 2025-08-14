module voting_system::dashboard;
use sui::types;


// Erroor codes 
const EDuplicateProposal: u64 = 0;
const EInvalidOtw: u64 = 1;

// use voting_system::proposal::{create};


public struct AdminCap has key {
    id: UID,
}



public struct Dashboard has key {
    id: UID,
    proposal_ids: vector<ID>
}


public struct DASHBOARD has drop {}


// Hot potato pattern it can not be stored, copied, discarded
public struct Potato {}



fun init(_otw: DASHBOARD, ctx: &mut TxContext){

    new(_otw, ctx);

    transfer::transfer(
        AdminCap {id:object::new(ctx)},
        ctx.sender()
    )
}


public fun new(_otw:DASHBOARD, ctx: &mut TxContext) {

    assert!(types::is_one_time_witness(&_otw), EInvalidOtw);

    let dashboard: Dashboard = Dashboard {
        id: object::new(ctx),
        proposal_ids: vector::empty(),
    };


    transfer::share_object(dashboard);
}

public fun register_proposal(self: &mut Dashboard, _admin_cap: & AdminCap, proposal_id: ID) {
    assert!(!self.proposal_ids.contains(&proposal_id), EDuplicateProposal);

    self.proposal_ids.push_back(proposal_id);
}


public fun proposal_ids(self: &Dashboard) : vector<ID>{
    self.proposal_ids
}

#[test_only]
public fun issue_admin_cap(ctx: &mut TxContext) {
    transfer::transfer(AdminCap {id: object::new(ctx)}, ctx.sender());
}


#[test_only]
public fun new_otw(_ctx: &mut TxContext) :DASHBOARD {
    DASHBOARD{}
}


#[test]
fun test_module_init() {
    use sui::test_scenario;

    let user = @0xCA;

    let mut scenario = test_scenario::begin(user);
    {
        let otw = DASHBOARD{};
        init(otw, scenario.ctx());
    };

    scenario.next_tx(user);
    {
        let dashboard = scenario.take_shared<Dashboard>();
        assert!(dashboard.proposal_ids.is_empty());

        test_scenario::return_shared(dashboard);
    };

    scenario.end();

}


