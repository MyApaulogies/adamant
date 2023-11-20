--------------------------------------------------------------------------------
-- Time_Of_Tone_Master Tests Body
--------------------------------------------------------------------------------

with Basic_Assertions; use Basic_Assertions;
with Packed_U32.Assertion; use Packed_U32.Assertion;
with Tick.Assertion; use Tick.Assertion;
with Interfaces; use Interfaces;
with Invalid_Command_Info.Assertion; use Invalid_Command_Info.Assertion;
with Command_Response.Assertion; use Command_Response.Assertion;
with Command_Enums; use Command_Enums.Command_Response_Status;
with Command;
with Tat_State.Assertion; use Tat_State.Assertion;
use Tat_State;

package body Time_Of_Tone_Master_Tests.Implementation is

   -------------------------------------------------------------------------
   -- Fixtures:
   -------------------------------------------------------------------------

   overriding procedure Set_Up_Test (Self : in out Instance) is
   begin
      -- Allocate heap memory to component:
      Self.Tester.Init_Base;

      -- Make necessary connections between tester and component:
      Self.Tester.Connect;

      -- Call component init here.
      Self.Tester.Component_Instance.Init (Sync_Period => 3, Enabled_State => Enabled);

      -- Call the component set up method that the assembly would normally call.
      Self.Tester.Component_Instance.Set_Up;
   end Set_Up_Test;

   overriding procedure Tear_Down_Test (Self : in out Instance) is
   begin
      -- Free component heap:
      Self.Tester.Final_Base;
   end Tear_Down_Test;

   -------------------------------------------------------------------------
   -- Tests:
   -------------------------------------------------------------------------

   overriding procedure Test_Tone_Message (Self : in out Instance) is
      T : Component.Time_Of_Tone_Master.Implementation.Tester.Instance_Access renames Self.Tester;
   begin
      -- Test data products on startup:
      Natural_Assert.Eq (T.Data_Product_T_Recv_Sync_History.Get_Count, 3);
      Natural_Assert.Eq (T.Tone_Messages_Sent_History.Get_Count, 1);
      Packed_U32_Assert.Eq (T.Tone_Messages_Sent_History.Get (1), (Value => 0));
      Natural_Assert.Eq (T.Time_Messages_Sent_History.Get_Count, 1);
      Packed_U32_Assert.Eq (T.Time_Messages_Sent_History.Get (1), (Value => 0));
      Natural_Assert.Eq (T.Time_At_Tone_State_History.Get_Count, 1);
      Tat_State_Assert.Eq (T.Time_At_Tone_State_History.Get (1), (State => Enabled));

      -- Send the component ticks, and make sure time messages sent at appropriate time:
      T.Tick_T_Send (((0, 0), 0));
      Natural_Assert.Eq (T.Tone_Message_Recv_Sync_History.Get_Count, 1);
      Tick_Assert.Eq (T.Tone_Message_Recv_Sync_History.Get (1), (T.System_Time, 1));
      Natural_Assert.Eq (T.Data_Product_T_Recv_Sync_History.Get_Count, 4);
      Natural_Assert.Eq (T.Tone_Messages_Sent_History.Get_Count, 2);
      Packed_U32_Assert.Eq (T.Tone_Messages_Sent_History.Get (2), (Value => 1));
      --
      T.Tick_T_Send (((0, 0), 0));
      Natural_Assert.Eq (T.Tone_Message_Recv_Sync_History.Get_Count, 1);
      T.Tick_T_Send (((0, 0), 0));
      Natural_Assert.Eq (T.Tone_Message_Recv_Sync_History.Get_Count, 1);
      T.Tick_T_Send (((0, 0), 0));
      Natural_Assert.Eq (T.Tone_Message_Recv_Sync_History.Get_Count, 2);
      Tick_Assert.Eq (T.Tone_Message_Recv_Sync_History.Get (2), (T.System_Time, 2));
      Natural_Assert.Eq (T.Data_Product_T_Recv_Sync_History.Get_Count, 5);
      Natural_Assert.Eq (T.Tone_Messages_Sent_History.Get_Count, 3);
      Packed_U32_Assert.Eq (T.Tone_Messages_Sent_History.Get (3), (Value => 2));
      --
      T.Tick_T_Send (((0, 0), 0));
      Natural_Assert.Eq (T.Tone_Message_Recv_Sync_History.Get_Count, 2);
      T.Tick_T_Send (((0, 0), 0));
      Natural_Assert.Eq (T.Tone_Message_Recv_Sync_History.Get_Count, 2);
      T.Tick_T_Send (((0, 0), 0));
      Natural_Assert.Eq (T.Tone_Message_Recv_Sync_History.Get_Count, 3);
      Tick_Assert.Eq (T.Tone_Message_Recv_Sync_History.Get (3), (T.System_Time, 3));
      Natural_Assert.Eq (T.Data_Product_T_Recv_Sync_History.Get_Count, 6);
      Natural_Assert.Eq (T.Tone_Messages_Sent_History.Get_Count, 4);
      Packed_U32_Assert.Eq (T.Tone_Messages_Sent_History.Get (4), (Value => 3));

      -- No events:
      Natural_Assert.Eq (T.Event_T_Recv_Sync_History.Get_Count, 0);
   end Test_Tone_Message;

   overriding procedure Test_Time_Message (Self : in out Instance) is
      T : Component.Time_Of_Tone_Master.Implementation.Tester.Instance_Access renames Self.Tester;
   begin
      -- Test data products on startup:
      Natural_Assert.Eq (T.Data_Product_T_Recv_Sync_History.Get_Count, 3);
      Natural_Assert.Eq (T.Tone_Messages_Sent_History.Get_Count, 1);
      Packed_U32_Assert.Eq (T.Tone_Messages_Sent_History.Get (1), (Value => 0));
      Natural_Assert.Eq (T.Time_Messages_Sent_History.Get_Count, 1);
      Packed_U32_Assert.Eq (T.Time_Messages_Sent_History.Get (1), (Value => 0));
      Natural_Assert.Eq (T.Time_At_Tone_State_History.Get_Count, 1);
      Tat_State_Assert.Eq (T.Time_At_Tone_State_History.Get (1), (State => Enabled));

      -- Send the component tone times, and make sure time messages sent at appropriate time:
      T.Tone_Message_Sys_Time_T_Send ((1, 2));
      Natural_Assert.Eq (T.Time_Message_Recv_Sync_History.Get_Count, 1);
      Tick_Assert.Eq (T.Time_Message_Recv_Sync_History.Get (1), ((1, 2), 1));
      Natural_Assert.Eq (T.Data_Product_T_Recv_Sync_History.Get_Count, 4);
      Natural_Assert.Eq (T.Time_Messages_Sent_History.Get_Count, 2);
      Packed_U32_Assert.Eq (T.Time_Messages_Sent_History.Get (2), (Value => 1));

      -- Send the component tone times, and make sure time messages sent at appropriate time:
      T.Tone_Message_Sys_Time_T_Send ((2, 3));
      Natural_Assert.Eq (T.Time_Message_Recv_Sync_History.Get_Count, 2);
      Tick_Assert.Eq (T.Time_Message_Recv_Sync_History.Get (2), ((2, 3), 2));
      Natural_Assert.Eq (T.Data_Product_T_Recv_Sync_History.Get_Count, 5);
      Natural_Assert.Eq (T.Time_Messages_Sent_History.Get_Count, 3);
      Packed_U32_Assert.Eq (T.Time_Messages_Sent_History.Get (3), (Value => 2));

      -- Send the component tone times, and make sure time messages sent at appropriate time:
      T.Tone_Message_Sys_Time_T_Send ((Unsigned_32'Last, Unsigned_32'Last - 53));
      Natural_Assert.Eq (T.Time_Message_Recv_Sync_History.Get_Count, 3);
      Tick_Assert.Eq (T.Time_Message_Recv_Sync_History.Get (3), ((Unsigned_32'Last, Unsigned_32'Last - 53), 3));
      Natural_Assert.Eq (T.Data_Product_T_Recv_Sync_History.Get_Count, 6);
      Natural_Assert.Eq (T.Time_Messages_Sent_History.Get_Count, 4);
      Packed_U32_Assert.Eq (T.Time_Messages_Sent_History.Get (4), (Value => 3));

      -- No events:
      Natural_Assert.Eq (T.Event_T_Recv_Sync_History.Get_Count, 0);
   end Test_Time_Message;

   overriding procedure Test_Enable_Disabled (Self : in out Instance) is
      T : Component.Time_Of_Tone_Master.Implementation.Tester.Instance_Access renames Self.Tester;
   begin
      T.Data_Product_T_Recv_Sync_History.Clear; -- ignore startup data products
      T.Time_At_Tone_State_History.Clear;
      T.Tone_Messages_Sent_History.Clear;
      T.Time_Messages_Sent_History.Clear;

      -- Disable:
      T.Command_T_Send (T.Commands.Disable_Time_At_Tone);
      Natural_Assert.Eq (T.Command_Response_T_Recv_Sync_History.Get_Count, 1);
      Command_Response_Assert.Eq (T.Command_Response_T_Recv_Sync_History.Get (1), (Source_Id => 0, Registration_Id => 0, Command_Id => T.Commands.Get_Disable_Time_At_Tone_Id, Status => Success));

      -- Check events:
      Natural_Assert.Eq (T.Event_T_Recv_Sync_History.Get_Count, 1);
      Natural_Assert.Eq (T.Time_At_Tone_Disabled_History.Get_Count, 1);

      -- Check data products:
      Natural_Assert.Eq (T.Data_Product_T_Recv_Sync_History.Get_Count, 1);
      Natural_Assert.Eq (T.Time_At_Tone_State_History.Get_Count, 1);
      Tat_State_Assert.Eq (T.Time_At_Tone_State_History.Get (1), (State => Disabled));

      -- No syncing messages should be sent:
      for Idx in 0 .. 100 loop
         T.Tick_T_Send (((0, 0), 0));
         Natural_Assert.Eq (T.Time_Message_Recv_Sync_History.Get_Count, 0);
         Natural_Assert.Eq (T.Tone_Message_Recv_Sync_History.Get_Count, 0);
      end loop;

      -- Set period to one and reenable:
      Self.Tester.Component_Instance.Init (Sync_Period => 1, Enabled_State => Disabled);

      -- Call the component set up method that the assembly would normally call.
      Self.Tester.Component_Instance.Set_Up;

      -- Test data products on startup:
      Natural_Assert.Eq (T.Data_Product_T_Recv_Sync_History.Get_Count, 4);
      Natural_Assert.Eq (T.Tone_Messages_Sent_History.Get_Count, 1);
      Packed_U32_Assert.Eq (T.Tone_Messages_Sent_History.Get (1), (Value => 0));
      Natural_Assert.Eq (T.Time_Messages_Sent_History.Get_Count, 1);
      Packed_U32_Assert.Eq (T.Time_Messages_Sent_History.Get (1), (Value => 0));
      Natural_Assert.Eq (T.Time_At_Tone_State_History.Get_Count, 2);
      Tat_State_Assert.Eq (T.Time_At_Tone_State_History.Get (2), (State => Disabled));

      -- Enable:
      T.Command_T_Send (T.Commands.Enable_Time_At_Tone);
      Natural_Assert.Eq (T.Command_Response_T_Recv_Sync_History.Get_Count, 2);
      Command_Response_Assert.Eq (T.Command_Response_T_Recv_Sync_History.Get (2), (Source_Id => 0, Registration_Id => 0, Command_Id => T.Commands.Get_Enable_Time_At_Tone_Id, Status => Success));

      -- Check events:
      Natural_Assert.Eq (T.Event_T_Recv_Sync_History.Get_Count, 2);
      Natural_Assert.Eq (T.Time_At_Tone_Enabled_History.Get_Count, 1);

      -- Check data products:
      Natural_Assert.Eq (T.Data_Product_T_Recv_Sync_History.Get_Count, 5);
      Natural_Assert.Eq (T.Time_At_Tone_State_History.Get_Count, 3);
      Tat_State_Assert.Eq (T.Time_At_Tone_State_History.Get (3), (State => Enabled));

      -- Syncing messages should be sent every tick:
      for Idx in 1 .. 5 loop
         T.Tick_T_Send (((0, 0), 0));
         Natural_Assert.Eq (T.Tone_Message_Recv_Sync_History.Get_Count, Idx);
         Tick_Assert.Eq (T.Tone_Message_Recv_Sync_History.Get (Idx), (T.System_Time, Unsigned_32 (Idx)));
         Natural_Assert.Eq (T.Data_Product_T_Recv_Sync_History.Get_Count, Idx + 5);
         Natural_Assert.Eq (T.Tone_Messages_Sent_History.Get_Count, Idx + 1);
         Packed_U32_Assert.Eq (T.Tone_Messages_Sent_History.Get (Idx + 1), (Value => Unsigned_32 (Idx)));
      end loop;
   end Test_Enable_Disabled;

   overriding procedure Test_Sync_Once (Self : in out Instance) is
      T : Component.Time_Of_Tone_Master.Implementation.Tester.Instance_Access renames Self.Tester;
   begin
      T.Data_Product_T_Recv_Sync_History.Clear; -- ignore startup data products
      T.Time_At_Tone_State_History.Clear;
      T.Tone_Messages_Sent_History.Clear;
      T.Time_Messages_Sent_History.Clear;

      -- Init with syncing disabled:
      Self.Tester.Component_Instance.Init (Sync_Period => 1, Enabled_State => Disabled);

      -- No syncing messages should be sent:
      for Idx in 0 .. 100 loop
         T.Tick_T_Send (((0, 0), 0));
         Natural_Assert.Eq (T.Time_Message_Recv_Sync_History.Get_Count, 0);
         Natural_Assert.Eq (T.Tone_Message_Recv_Sync_History.Get_Count, 0);
      end loop;

      -- Send sync once command:
      T.Command_T_Send (T.Commands.Sync_Once);
      Natural_Assert.Eq (T.Command_Response_T_Recv_Sync_History.Get_Count, 1);
      Command_Response_Assert.Eq (T.Command_Response_T_Recv_Sync_History.Get (1), (Source_Id => 0, Registration_Id => 0, Command_Id => T.Commands.Get_Sync_Once_Id, Status => Success));

      -- Check events:
      Natural_Assert.Eq (T.Event_T_Recv_Sync_History.Get_Count, 1);
      Natural_Assert.Eq (T.Sending_Sync_Once_History.Get_Count, 1);

      -- Send tick
      T.Tick_T_Send (((0, 0), 0));
      Natural_Assert.Eq (T.Tone_Message_Recv_Sync_History.Get_Count, 1);
      Tick_Assert.Eq (T.Tone_Message_Recv_Sync_History.Get (1), (T.System_Time, 1));
      Natural_Assert.Eq (T.Data_Product_T_Recv_Sync_History.Get_Count, 1);
      Natural_Assert.Eq (T.Tone_Messages_Sent_History.Get_Count, 1);
      Packed_U32_Assert.Eq (T.Tone_Messages_Sent_History.Get (1), (Value => 1));

      -- No syncing messages should be sent:
      for Idx in 0 .. 100 loop
         T.Tick_T_Send (((0, 0), 0));
         Natural_Assert.Eq (T.Time_Message_Recv_Sync_History.Get_Count, 0);
         Natural_Assert.Eq (T.Tone_Message_Recv_Sync_History.Get_Count, 1);
      end loop;

      -- Send sync once command:
      T.Command_T_Send (T.Commands.Sync_Once);
      Natural_Assert.Eq (T.Command_Response_T_Recv_Sync_History.Get_Count, 2);
      Command_Response_Assert.Eq (T.Command_Response_T_Recv_Sync_History.Get (2), (Source_Id => 0, Registration_Id => 0, Command_Id => T.Commands.Get_Sync_Once_Id, Status => Success));

      -- Check events:
      Natural_Assert.Eq (T.Event_T_Recv_Sync_History.Get_Count, 2);
      Natural_Assert.Eq (T.Sending_Sync_Once_History.Get_Count, 2);

      -- Send tick
      T.Tick_T_Send (((0, 0), 0));
      Natural_Assert.Eq (T.Tone_Message_Recv_Sync_History.Get_Count, 2);
      Tick_Assert.Eq (T.Tone_Message_Recv_Sync_History.Get (2), (T.System_Time, 2));
      Natural_Assert.Eq (T.Data_Product_T_Recv_Sync_History.Get_Count, 2);
      Natural_Assert.Eq (T.Tone_Messages_Sent_History.Get_Count, 2);
      Packed_U32_Assert.Eq (T.Tone_Messages_Sent_History.Get (2), (Value => 2));

      -- No syncing messages should be sent:
      for Idx in 0 .. 100 loop
         T.Tick_T_Send (((0, 0), 0));
         Natural_Assert.Eq (T.Tone_Message_Recv_Sync_History.Get_Count, 2);
      end loop;
   end Test_Sync_Once;

   overriding procedure Test_Invalid_Command (Self : in out Instance) is
      T : Component.Time_Of_Tone_Master.Implementation.Tester.Instance_Access renames Self.Tester;
      Cmd : Command.T := T.Commands.Enable_Time_At_Tone;
   begin
      -- Make the command invalid by modifying its length.
      Cmd.Header.Arg_Buffer_Length := 1;

      -- Send bad command and expect bad response:
      T.Command_T_Send (Cmd);
      Natural_Assert.Eq (T.Command_Response_T_Recv_Sync_History.Get_Count, 1);
      Command_Response_Assert.Eq (T.Command_Response_T_Recv_Sync_History.Get (1), (Source_Id => 0, Registration_Id => 0, Command_Id => T.Commands.Get_Enable_Time_At_Tone_Id, Status => Length_Error));

      -- Make sure some events were thrown:
      Natural_Assert.Eq (T.Event_T_Recv_Sync_History.Get_Count, 1);
      Natural_Assert.Eq (T.Time_At_Tone_Enabled_History.Get_Count, 0);
      Natural_Assert.Eq (T.Invalid_Command_Received_History.Get_Count, 1);
      Invalid_Command_Info_Assert.Eq (T.Invalid_Command_Received_History.Get (1), (Id => T.Commands.Get_Enable_Time_At_Tone_Id, Errant_Field_Number => Interfaces.Unsigned_32'Last, Errant_Field => (0, 0, 0, 0, 0, 0, 0, 1)));
   end Test_Invalid_Command;

end Time_Of_Tone_Master_Tests.Implementation;
