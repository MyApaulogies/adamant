--------------------------------------------------------------------------------
-- Data_Dependency_Component Tests Spec
--------------------------------------------------------------------------------

-- This is a set of unit tests for the Data Dependency Component.
package Data_Dependency_Component_Tests.Implementation is
   -- Test data and state:
   type Instance is new Data_Dependency_Component_Tests.Base_Instance with private;
   type Class_Access is access all Instance'Class;
private
   -- Fixture procedures:
   overriding procedure Set_Up_Test (Self : in out Instance);
   overriding procedure Tear_Down_Test (Self : in out Instance);

   -- The unit test.
   overriding procedure Unit_Test (Self : in out Instance);

   -- Test data and state:
   type Instance is new Data_Dependency_Component_Tests.Base_Instance with record
      null;
   end record;
end Data_Dependency_Component_Tests.Implementation;
