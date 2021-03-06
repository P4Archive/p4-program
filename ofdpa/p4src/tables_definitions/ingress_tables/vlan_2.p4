/*****************************************************************************/
/*                            VLAN 2 flow table                              */
/*                Implement only with outer VLAN label                       */
/*                     Outer lable is vlan_tag_[0]                           */
/*****************************************************************************/


action modify_vlan_2_tag(vid) {
    modify_field(vlan_tag_[0].vid, vid);        
    modify_field(intrinsic_metadata.vlan_2_hit, 1);
}


action pop_vlan_2_tag() {
    modify_field(ethernet.etherType, vlan_tag_[0].etherType);
    remove_header(vlan_tag_[0]);
    modify_field(intrinsic_metadata.vlan_2_hit, 1);
}


action push_vlan_2_tag(vid) {
    // Add second label
    modify_field(ethernet.etherType, ETHERTYPE_QINQ);
    add_header(vlan_tag_[1]);
    // copy_header(destination, source)
    copy_header(vlan_tag_[0], vlan_tag_[1]);
    modify_field(vlan_tag_[0].etherType, ETHERTYPE_ONE_VLAN);
    modify_field(vlan_tag_[0].vid, vid);

    modify_field(intrinsic_metadata.vlan_2_hit, 1);
}


action modify_vlan_2_tag_and_push_vlan_tag(vid_inner, vid_outer) {
    modify_field(vlan_tag_[0].vid, vid_inner);
    modify_field(ethernet.etherType, ETHERTYPE_QINQ);
    add_header(vlan_tag_[1]);
    copy_header(vlan_tag_[0], vlan_tag_[1]);
    modify_field(vlan_tag_[0].etherType, ETHERTYPE_ONE_VLAN);
    modify_field(vlan_tag_[0].vid, vid_outer);
    modify_field(intrinsic_metadata.vlan_2_hit, 1);
}


table vlan_2 {
    reads {
        standard_metadata.ingress_port : exact;
        vlan_tag_[0].vid               : exact;
    }
    actions {
        // optionaly set VRF

        modify_vlan_2_tag;
        pop_vlan_2_tag;
        push_vlan_2_tag;
        modify_vlan_2_tag_and_push_vlan_tag;
    }
    size : VLAN_2_FLOW_TABLE_SIZE;
}


control process_vlan_2 {
    // Now only one label in packet
    // This label is vlan_tag_[0]
    apply(vlan_2);
    if (intrinsic_metadata.vlan_2_hit == 1) {
        // HIT
        process_termination_mac();
    } else {
        // MISS
        process_policy_acl();
    }
}