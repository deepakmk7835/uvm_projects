class vcore_base_env#(type CFG_T = vcore_base_env_cfg, type SEQ_ITEM_T = uvm_sequence_item) extends uvm_env;
    `uvm_component_param_utils(vcore_base_env#(CFG_T, SEQ_ITEM_T))

    CFG_T cfg;
    vcore_base_agent#(CFG_T, SEQ_ITEM_T) agt;
    vcore_base_scb#(CFG_T, SEQ_ITEM_T) scb;

    function new(string name = "", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(vcore_base_env_cfg)::get(this,"","cfg", cfg)) begin 
            `uvm_fatal("VCORE_BASE_ENV", "Unable to get base_env_cfg from config_db")
        end
        agt = vcore_base_agent#(CFG_T, SEQ_ITEM_T)::type_id::create("agt", this);
        uvm_config_db#(vcore_base_agt_cfg)::set(this,"agt*","agt_cfg", cfg.agent_cfg);
        if(cfg.get_enable_scb()) begin
            scb = vcore_base_scb#(CFG_T, SEQ_ITEM_T)::type_id::create("scb", this);
            scb.cfg = cfg;
        end
    endfunction: build_phase

endclass: vcore_base_env