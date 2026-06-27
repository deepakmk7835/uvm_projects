class vcore_base_env_cfg extends uvm_object;
    `uvm_object_utils(vcore_base_env_cfg)

    bit enable_scb=1;
    bit enable_cov=0;

    vcore_base_agt_cfg agent_cfg;

    function new(string name = "");
        super.new(name);
        agent_cfg = vcore_base_agt_cfg::type_id::create("agent_cfg");
    endfunction: new

    function void set_enable_scb(bit val);
        enable_scb = val;
    endfunction: set_enable_scb

    function bit get_enable_scb();
        return enable_scb;
    endfunction: get_enable_scb

    function void set_enable_cov(bit val);
        enable_cov = val;
    endfunction: set_enable_cov

    function bit get_enable_cov();
        return enable_cov;
    endfunction: get_enable_cov
endclass: vcore_base_env_cfg