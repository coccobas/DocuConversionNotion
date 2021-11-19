Precision Landing State Machine
==========================================

.. mermaid::

   stateDiagram-v2
        [*] --> on_activation
        [*] --> on_inactivation

        on_activation: get_local_position
        on_activation: get_position_setpoint_triplet

        on_activation --> on_active : while get new target measurement


        State on_active {

            [*] --> start
            State start
                start: run_state_start

            State HorizontalApproach
                HorizontalApproach: run_state_horizontal_approach
            State DescendAboveTarget
                DescendAboveTarget: run_state_descend_above_target
            State FinalApproach
                FinalApproach: run_state_final_approach
            State Search
                Search: run_state_search
            State Fallback
                Fallback: run_state_fallback
            State Done

            start --> HorizontalApproach: if in Opportunistic/Required mode target visible 
            start --> Fallback: if in Opportunistic mode target not visible 
            start --> Search: if in Required mode target not visible 

            start : check_state_conditions
            HorizontalApproach : check_state_conditions
            DescendAboveTarget: check_state_conditions
            FinalApproach: check_state_conditions

            Search --> HorizontalApproach : if target visible and stay for 1s
            Search --> Fallback : if search timeout

            HorizontalApproach --> DescendAboveTarget: if target in PLD_HACC_RAD switch_to_state_descend_above_target
            HorizontalApproach --> HorizontalApproach: if target not in range PLD_HACC_RAD
            HorizontalApproach --> start : if target lost

            DescendAboveTarget --> FinalApproach : if target stable switch_to_state_final_approach
            DescendAboveTarget --> DescendAboveTarget
            FinalApproach --> Done : check_state_conditions

            Fallback --> NormalLand

            start --> DescendWhileSearch: in Conditional mode Search while descending in current location 
            DescendWhileSearch --> DescendWhileSearch : if target not visible above PLD_CFB_ALT
            DescendWhileSearch --> HorizontalApproach: if target visible and stay for 1s
            DescendWhileSearch --> DescendAboveTarget: if target in range PLD_HACC_RAD for 0.5s(faster approach)
            DescendWhileSearch --> Fallback : if target lost or not stable enough below PLD_CFB_ALT
        }
