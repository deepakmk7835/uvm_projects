class vcore_base_driver#(type CFG_T = vcore_base_env_cfg, type SEQ_ITEM_T = uvm_sequence_item) extends uvm_driver#(SEQ_ITEM_T);
    `uvm_component_param_utils(vcore_base_driver#(CFG_T, SEQ_ITEM_T))

    CFG_T cfg;

    function new(string name = "", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(vcore_base_env_cfg)::get(this,"","cfg", cfg)) begin 
            `uvm_fatal("vcore_base_driver", "Unable to get base_env_cfg from config_db")
        end
    endfunction: build_phase

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
    endfunction: connect_phase

    // Extending class must override this task to avoid compilation error!
    virtual task run_phase(uvm_phase phase);
        `uvm_fatal(get_type_name(), "vcore_base_driver run_phase not overriden by extending class!")
    endtask: run_phase

endclass: vcore_base_driver