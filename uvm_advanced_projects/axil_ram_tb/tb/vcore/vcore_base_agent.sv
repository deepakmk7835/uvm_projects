class vcore_base_agent#(type CFG_T = vcore_base_env_cfg, type SEQ_ITEM_T = uvm_sequence_item) extends uvm_agent;
    `uvm_component_param_utils(vcore_base_agent#(CFG_T, SEQ_ITEM_T))

    CFG_T cfg;
    vcore_base_agent_cfg agt_cfg;
    vcore_base_driver#(CFG_T, SEQ_ITEM_T) drv;
    vcore_base_seqr#(CFG_T, SEQ_ITEM_T) seqr;
    vcore_base_monitor#(CFG_T, SEQ_ITEM_T) mon;

    function new(string name = "", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(vcore_base_agt_cfg)::get(this,"","agt_cfg", agt_cfg)) begin 
            `uvm_fatal("vcore_base_agent", "Unable to get base_agent_cfg from config_db")
        end
        if(agt_cfg.get_is_active() == UVM_ACTIVE) begin 
            drv = vcore_base_driver#(CFG_T, SEQ_ITEM_T)::type_id::create("drv", this);
            seqr = vcore_base_seqr#(CFG_T, SEQ_ITEM_T)::type_id::create("seqr", this);
        end
        mon = vcore_base_monitor#(CFG_T, SEQ_ITEM_T)::type_id::create("mon", this);
    endfunction: build_phase

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        if(agt_cfg.get_is_active() == UVM_ACTIVE) begin 
            drv.seq_item_port.connect(seqr.seq_item_export);
        end
    endfunction: connect_phase

endclass: vcore_base_agent