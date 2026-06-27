class vcore_base_scb#(type CFG_T = vcore_base_env_cfg, type SEQ_ITEM_T = uvm_sequence_item) extends uvm_scoreboard;
    `uvm_component_param_utils(vcore_base_scb#(CFG_T, SEQ_ITEM_T))

    CFG_T cfg;

    uvm_tlm_analysis_fifo#(SEQ_ITEM_T) req_fifo;
    uvm_tlm_analysis_fifo#(SEQ_ITEM_T) resp_fifo;

    uvm_analysis_export#(SEQ_ITEM_T) req_exp;
    uvm_analysis_export#(SEQ_ITEM_T) resp_exp;

    function new(string name = "", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(vcore_base_env_cfg)::get(this,"","cfg", cfg)) begin 
            `uvm_fatal("VCORE_BASE_SCB", "Unable to get base_env_cfg from config_db")
        end
        req_exp = new("req_exp", this);
        resp_exp = new("resp_exp", this);
        req_fifo = new("req_fifo", this);
        resp_fifo = new("resp_fifo", this);
    endfunction: build_phase

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        req_exp.connect(req_fifo.analysis_export);
        resp_exp.connect(resp_fifo.analysis_export);
    endfunction: connect_phase

    // Extending class must override this task to avoid compilation error!
    virtual task run_phase(uvm_phase phase);
        `uvm_fatal(get_type_name(), "vcore_base_scb run_phase not overriden by extending class!")
    endtask: run_phase

endclass: vcore_base_scb