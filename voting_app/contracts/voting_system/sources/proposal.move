
module voting_system::proposal;
use std::string::String;
use voting_system::dashboard::AdminCap;
use sui::table::{Self, Table};
use sui::url::{Url, new_unsafe_from_bytes};

const EDuplicateVote:u64 = 0;

public enum ProposalStatus has store, drop{
    Active,
    Delisted,
}


public struct Proposal has key {
    id: UID,
    title: String,
    description: String,
    voted_yes_count: u64,
    voted_no_count: u64,
    expiration: u64,
    status: ProposalStatus,
    creator: address,
    voters:Table<address, bool>,
}

public struct VoteProofNFT has key {
    id: UID,
    proposal_id: ID,
    name: String,
    description:String,
    url: Url

}


public fun create(
    _admin_cap: &AdminCap,
    title: String,
    description: String,
    expiration: u64,
    ctx: &mut TxContext,
) :ID {
    let proposal: Proposal = Proposal {
        id: object::new(ctx),
        title,
        description,
        voted_yes_count: 0,
        voted_no_count: 0,
        expiration,
        status: ProposalStatus::Active,
        creator: ctx.sender(),
        voters: table::new(ctx),
    };
    

    let id = proposal.id.to_inner();
    transfer::share_object(proposal);

    id
}



public fun vote(self: &mut Proposal, vote_yes: bool, ctx: &mut TxContext){
    assert!(!self.voters.contains(ctx.sender()), EDuplicateVote);


    if (vote_yes){
        self.voted_yes_count = self.voted_yes_count + 1;
    }else{
        self.voted_no_count = self.voted_no_count + 1;
    };

    self.voters.add(ctx.sender(), vote_yes);

    issue_vote_proof(self, vote_yes, ctx);

}





public fun title(proposal: &Proposal): String {
    proposal.title
}

public fun desc(proposal: &Proposal): String {
    proposal.description
}

public fun voted_yes_count(proposal: &Proposal): u64 {
    proposal.voted_yes_count
}

public fun voted_no_count(proposal: &Proposal): u64 {
    proposal.voted_no_count
}

public fun expiration(proposal: &Proposal): u64 {
    proposal.expiration
}

public fun creator(proposal: &Proposal): address {
    proposal.creator
}

public fun voters(proposal: &Proposal): &Table<address, bool> {
    &proposal.voters
}


public fun vote_proof_nft(self: &VoteProofNFT): Url{
    self.url
}


public fun change_status(self: &mut Proposal, _admin_cap: &AdminCap, status: ProposalStatus){
    self.status = status;
}

public fun proposal_status(self:&Proposal): &ProposalStatus {
    &self.status
}




fun issue_vote_proof(proposal: &Proposal, vote_yes: bool, ctx: &mut TxContext) {
    let mut name = b"NFT_".to_string();
    name.append(proposal.title);
    let mut description = b"Proof of voting on ".to_string();
    let proposal_address = object::id_address(proposal).to_string();
    description.append(proposal_address);

    let vote_no_image = new_unsafe_from_bytes(b"https://singforamoment.sirv.com/nft_no.png");

    let vote_yes_image = new_unsafe_from_bytes(b"https://singforamoment.sirv.com/nft_yes.png");

    let url = if (vote_yes) {vote_yes_image} else {vote_no_image};


    let proof = VoteProofNFT {
        id: object::new(ctx),
        proposal_id: proposal.id.to_inner(),
        name,
        description,
        url
    };

    transfer::transfer(proof, ctx.sender());
}