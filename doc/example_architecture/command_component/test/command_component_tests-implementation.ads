--------------------------------------------------------------------------------
-- Command_Component Tests Spec
--------------------------------------------------------------------------------

-- This is a set of unit tests for the Command Component.
package Command_Component_Tests.Implementation is
   -- Test data and state:
   type Instance is new Command_Component_Tests.Base_Instance with private;
private
   -- Fixture procedures:
   overriding procedure Set_Up_Test (Self : in out Instance);
   overriding procedure Tear_Down_Test (Self : in out Instance);

   -- The unit test.
   overriding procedure Unit_Test (Self : in out Instance);

   -- Test data and state:
   type Instance is new Command_Component_Tests.Base_Instance with record
      null;
   end record;
end Command_Component_Tests.Implementation;
