/*
 * Layer-3 processing
 */

/*
 * L3 Metadata
 */

header_type l3_metadata_t {
    fields {
        lkp_ip_type : 2;
        lkp_ip_version : 4;
        lkp_ip_proto : 8;
        lkp_dscp : 8;
        lkp_ip_ttl : 8;
        lkp_l4_sport : 16;
        lkp_l4_dport : 16;
        lkp_outer_l4_sport : 16;
        lkp_outer_l4_dport : 16;

        vrf : VRF_BIT_WIDTH;                   /* VRF */
        rmac_group : 10;                       /* Rmac group, for rmac indirection */
        rmac_hit : 1;                          /* dst mac is the router's mac */
        urpf_mode : 2;                         /* urpf mode for current lookup */
        urpf_hit : 1;                          /* hit in urpf table */
        urpf_check_fail :1;                    /* urpf check failed */
        urpf_bd_group : BD_BIT_WIDTH;          /* urpf bd group */
        fib_hit : 1;                           /* fib hit */
        fib_nexthop : 16;                      /* next hop from fib */
        fib_nexthop_type : 2;                  /* ecmp or nexthop */
        same_bd_check : BD_BIT_WIDTH;          /* ingress bd xor egress bd */
        nexthop_index : 16;                    /* nexthop/rewrite index */
        routed : 1;                            /* is packet routed? */
        outer_routed : 1;                      /* is outer packet routed? */
        mtu_index : 8;                         /* index into mtu table */
        l3_copy : 1;                           /* copy packet to CPU */
        l3_mtu_check : 16 (saturating);        /* result of mtu check */

        egress_l4_sport : 16;
        egress_l4_dport : 16;
    }
}

metadata l3_metadata_t l3_metadata;
