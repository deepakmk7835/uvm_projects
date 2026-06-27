class vcore_base_agt_cfg extends uvm_object;
    `uvm_object_utils(vcore_base_agt_cfg)

    uvm_active_passive_enum is_active = UVM_ACTIVE;

    function new(string name = "");
        super.new(name);
    endfunction: new

    function uvm_active_passive_enum get_is_active();
        return is_active;
    endfunction: get_is_active

    function void set_is_active(uvm_active_passive_enum val);
        is_active = val;
    endfunction: set_is_active
endclass: vcore_base_agt_cfg