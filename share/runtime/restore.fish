function fishtape_restore_globals
    for scope in --global --universal
        set $scope --name | sed -nE 's/^__fishtape_(.*)/\1 &/p' | while read -l var old_var
            set $scope $var $$old_var
        end
    end

    return 0
end
