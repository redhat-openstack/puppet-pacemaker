Puppet::Type.type(:pcmk_constraint).provide(:default) do
    desc 'A base constraint definition for a pacemaker constraint'

    ### overloaded methods
    def create
        resource_resource = @resource[:resource].gsub(':', '.')
        resource_name = @resource[:name].gsub(':', '.')
        case @resource[:constraint_type]
        when :location
            resource_location = @resource[:location].gsub(':', '.')
            cmd = 'constraint location add ' + resource_name + ' '  + resource_resource + ' ' + @resource[:location] + ' ' + @resource[:score]
        when :location_rule
            cmd = 'constraint location ' + resource_resource + ' rule resource-discovery=' + @resource[:resource_discovery] + ' score=' + @resource[:score] + ' ' + @resource[:expression]
        when :colocation
            resource_location = @resource[:location].gsub(':', '.')
            if @resource[:master_slave]
              cmd = 'constraint colocation add ' + resource_resource + ' with master ' + resource_location + ' ' + @resource[:score]
            else 
              cmd = 'constraint colocation add ' + resource_resource + ' with ' + resource_location + ' ' + @resource[:score]
            end
        else
            fail(String(@resource[:constraint_type]) + ' is an invalid location type')
        end

        # do pcs create
        pcs('create constraint', cmd)
    end

    def destroy
        resource_resource = @resource[:resource].gsub(':', '.')
        resource_name = @resource[:name].gsub(':', '.')
        case @resource[:constraint_type]
        when :location
            cmd = 'constraint location remove ' + resource_name
        when :location_rule
            cmd = 'constraint remove ' + resource_name
        when :colocation
            resource_location = @resource[:location].gsub(':', '.')
            cmd = 'constraint colocation remove ' + resource_resource + ' ' + resource_location
        end

        pcs('constraint delete', cmd)
    end

    def exists?
        resource_name = @resource[:name].gsub(':', '.')
        resource_resource = @resource[:resource].gsub(':', '.')
        if @resource[:constraint_type] == :location_rule
          cmd = 'constraint location show --full'
        else
          resource_location = @resource[:location].gsub(':', '.')
          cmd = 'constraint ' + String(@resource[:constraint_type]) + ' show --full'
        end
        pcs_out = pcs('show', cmd)
        # find the constraint
        for line in pcs_out.lines.each do
            case @resource[:constraint_type]
            when :location
                return true if line.include? resource_name
            when :colocation
                if @resource[:master_slave]
                  return true if line.include? resource_resource + ' with ' + resource_location and line.include? "with-rsc-role:Master"
                else
                  return true if line.include? resource_resource + ' with ' + resource_location
                end
            when :location_rule
                return true if line.include? resource_resource and line.include? "resource-discovery=" + @resource[:resource_discovery]
            end

        end
        # return false if constraint not found
        false
    end

    private

    def pcs(name, cmd)
        pcs_out = `/usr/sbin/pcs #{cmd}`
        puts cmd
        #puts $?.exitstatus
        #puts pcs_out
        if $?.exitstatus != 0 and not name.include? 'show'
            if pcs_out.lines.first 
                raise Puppet::Error, "pcs #{name} failed: #{pcs_out.lines.first.chomp!}" if $?.exitstatus
            else
                raise Puppet::Error, "pcs #{name} failed" if $?.exitstatus
            end
        end
        # return output for good exit or false for failure.
        $?.exitstatus == 0 ? pcs_out : false
    end
end
