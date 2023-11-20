name=`basename $2`
redo-ifchange build/template/$name

cat build/template/$name | awk '
/with AUnit.Assertions/ {
  print "with Ada.Text_IO; use Ada.Text_IO;"
  print "with Aa.Representation;"
  print "with Bb;"
  print "with Smart_Assert;"
  print "with Basic_Assertions; use Basic_Assertions;"
  print "with Packed_Connector_Index.Assertion; use Packed_Connector_Index.Assertion;"
  next
}
/TODO declarations/ {
  print "      Data_A : Aa.T := (One => 17, Two => 23, Three => 5);"
  print "      Ignore : Bb.T;"
  print "      package A_Assert is new Smart_Assert.Basic (Aa.T, Aa.Representation.Image);"
}
/TODO replace/ {
  print "      Put_Line (\"Sending data on connectors... \");"
  print "      for Idx in Self.Tester.Connector_Aa_T_Send@Range loop"
  print "         Put_Line (\"Sending Aa_T_Send index \" & Natural@Image (Natural (Idx)));"
  print "         Self.Tester.Aa_T_Send (Idx, Data_A);"
  print "         Natural_Assert.Eq (Self.Tester.Packed_Connector_Index_T_Recv_Sync_History.Get_Count, Natural (Idx));"
  print "         Natural_Assert.Eq (Self.Tester.Aa_T_Recv_Sync_History.Get_Count, Natural (Idx));"
  print "         A_Assert.Eq (Self.Tester.Aa_T_Recv_Sync_History.Get (Positive (Idx)), Data_A);"
  print "         Packed_Connector_Index_Assert.Eq (Self.Tester.Packed_Connector_Index_T_Recv_Sync_History.Get (Positive (Idx)), (Index => Idx));"
  print "      end loop;"
  print "      Self.Tester.Aa_T_Recv_Sync_History.Clear;"
  print "      Self.Tester.Packed_Connector_Index_T_Recv_Sync_History.Clear;"
  print "      for Idx in Self.Tester.Connector_Aa_T_Send_2@Range loop"
  print "         Put_Line (\"Sending Aa_T_Send_2_Index index \" & Natural@Image (Natural (Idx)));"
  print "         Self.Tester.Aa_T_Send_2 (Idx, Data_A);"
  print "         Natural_Assert.Eq (Self.Tester.Packed_Connector_Index_T_Recv_Sync_History.Get_Count, Natural (Idx) - 1);"
  print "         Natural_Assert.Eq (Self.Tester.Aa_T_Recv_Sync_History.Get_Count, Natural (Idx) - 1);"
  print "         Natural_Assert.Eq (Self.Tester.Dispatch_All, 1);"
  print "         Natural_Assert.Eq (Self.Tester.Packed_Connector_Index_T_Recv_Sync_History.Get_Count, Natural (Idx));"
  print "         Natural_Assert.Eq (Self.Tester.Aa_T_Recv_Sync_History.Get_Count, Natural (Idx));"
  print "         A_Assert.Eq (Self.Tester.Aa_T_Recv_Sync_History.Get (Positive (Idx)), Data_A);"
  print "         Packed_Connector_Index_Assert.Eq (Self.Tester.Packed_Connector_Index_T_Recv_Sync_History.Get (Positive (Idx)), (Index => Idx));"
  print "      end loop;"
  print "      Self.Tester.Aa_T_Recv_Sync_History.Clear;"
  print "      Self.Tester.Packed_Connector_Index_T_Recv_Sync_History.Clear;"
  print "      for Idx in Self.Tester.Connector_Aa_T_Send_3@Range loop"
  print "         Put_Line (\"Sending Aa_T_Send_3 index \" & Natural@Image (Natural (Idx)));"
  print "         Self.Tester.Aa_T_Send_3 (Idx, Data_A);"
  print "         Natural_Assert.Eq (Self.Tester.Packed_Connector_Index_T_Recv_Sync_History.Get_Count, Natural (Idx));"
  print "         Natural_Assert.Eq (Self.Tester.Aa_T_Recv_Sync_History.Get_Count, Natural (Idx));"
  print "         A_Assert.Eq (Self.Tester.Aa_T_Recv_Sync_History.Get (Positive (Idx)), Data_A);"
  print "         Packed_Connector_Index_Assert.Eq (Self.Tester.Packed_Connector_Index_T_Recv_Sync_History.Get (Positive (Idx)), (Index => Idx));"
  print "      end loop;"
  print "      Self.Tester.Aa_T_Recv_Sync_History.Clear;"
  print "      Self.Tester.Packed_Connector_Index_T_Recv_Sync_History.Clear;"
  print "      for Idx in Self.Tester.Connector_Aa_T_Send_4@Range loop"
  print "         Put_Line (\"Sending Aa_T_Send_4_Index index \" & Natural@Image (Natural (Idx)));"
  print "         Self.Tester.Aa_T_Send_4 (Idx, Data_A);"
  print "         Natural_Assert.Eq (Self.Tester.Packed_Connector_Index_T_Recv_Sync_History.Get_Count, Natural (Idx) - 1);"
  print "         Natural_Assert.Eq (Self.Tester.Aa_T_Recv_Sync_History.Get_Count, Natural (Idx) - 1);"
  print "         Natural_Assert.Eq (Self.Tester.Dispatch_All, 1);"
  print "         Natural_Assert.Eq (Self.Tester.Packed_Connector_Index_T_Recv_Sync_History.Get_Count, Natural (Idx));"
  print "         Natural_Assert.Eq (Self.Tester.Aa_T_Recv_Sync_History.Get_Count, Natural (Idx));"
  print "         A_Assert.Eq (Self.Tester.Aa_T_Recv_Sync_History.Get (Positive (Idx)), Data_A);"
  print "         Packed_Connector_Index_Assert.Eq (Self.Tester.Packed_Connector_Index_T_Recv_Sync_History.Get (Positive (Idx)), (Index => Idx));"
  print "      end loop;"
  print "      Self.Tester.Aa_T_Recv_Sync_History.Clear;"
  print "      Self.Tester.Packed_Connector_Index_T_Recv_Sync_History.Clear;"
  print "      for Idx in Self.Tester.Connector_Aa_T_Request@Range loop"
  print "         Put_Line (\"Sending Aa_T_Request index \" & Natural@Image (Natural (Idx)));"
  print "         Ignore := Self.Tester.Aa_T_Request (Idx, Data_A);"
  print "         Natural_Assert.Eq (Self.Tester.Packed_Connector_Index_T_Recv_Sync_History.Get_Count, Natural (Idx));"
  print "         Packed_Connector_Index_Assert.Eq (Self.Tester.Packed_Connector_Index_T_Recv_Sync_History.Get (Positive (Idx)), (Index => Idx));"
  print "      end loop;"
  print "      Self.Tester.Aa_T_Recv_Sync_History.Clear;"
  print "      Self.Tester.Packed_Connector_Index_T_Recv_Sync_History.Clear;"
  print "      for Idx in Self.Tester.Connector_Aa_T_Request_2@Range loop"
  print "         Put_Line (\"Sending Aa_T_Request_2 index \" & Natural@Image (Natural (Idx)));"
  print "         Ignore := Self.Tester.Aa_T_Request_2 (Idx, Data_A);"
  print "         Natural_Assert.Eq (Self.Tester.Packed_Connector_Index_T_Recv_Sync_History.Get_Count, Natural (Idx));"
  print "         Packed_Connector_Index_Assert.Eq (Self.Tester.Packed_Connector_Index_T_Recv_Sync_History.Get (Positive (Idx)), (Index => Idx));"
  print "      end loop;"
  print "      Self.Tester.Aa_T_Recv_Sync_History.Clear;"
  print "      Self.Tester.Packed_Connector_Index_T_Recv_Sync_History.Clear;"
  print "      for Idx in Self.Tester.Connector_Bb_T_Get@Range loop"
  print "         Put_Line (\"Sending Bb_T_Get index \" & Natural@Image (Natural (Idx)));"
  print "         Ignore := Self.Tester.Bb_T_Get (Idx);"
  print "         Natural_Assert.Eq (Self.Tester.Packed_Connector_Index_T_Recv_Sync_History.Get_Count, Natural (Idx));"
  print "         Packed_Connector_Index_Assert.Eq (Self.Tester.Packed_Connector_Index_T_Recv_Sync_History.Get (Positive (Idx)), (Index => Idx));"
  print "      end loop;"
  print "      Self.Tester.Aa_T_Recv_Sync_History.Clear;"
  print "      Self.Tester.Packed_Connector_Index_T_Recv_Sync_History.Clear;"
  print "      for Idx in Self.Tester.Connector_Bb_T_Get_2@Range loop"
  print "         Put_Line (\"Sending Bb_T_Get_2 index \" & Natural@Image (Natural (Idx)));"
  print "         Ignore := Self.Tester.Bb_T_Get_2 (Idx);"
  print "         Natural_Assert.Eq (Self.Tester.Packed_Connector_Index_T_Recv_Sync_History.Get_Count, Natural (Idx));"
  print "         Packed_Connector_Index_Assert.Eq (Self.Tester.Packed_Connector_Index_T_Recv_Sync_History.Get (Positive (Idx)), (Index => Idx));"
  print "      end loop;"
  print "      Self.Tester.Aa_T_Recv_Sync_History.Clear;"
  print "      Self.Tester.Packed_Connector_Index_T_Recv_Sync_History.Clear;"
  print "      for Idx in Self.Tester.Connector_Aa_T_Provide@Range loop"
  print "         Put_Line (\"Sending Aa_T_Provide index \" & Natural@Image (Natural (Idx)));"
  print "         Self.Tester.Aa_T_Provide (Idx, Data_A);"
  print "         Natural_Assert.Eq (Self.Tester.Packed_Connector_Index_T_Recv_Sync_History.Get_Count, Natural (Idx));"
  print "         Natural_Assert.Eq (Self.Tester.Aa_T_Recv_Sync_History.Get_Count, Natural (Idx));"
  print "         A_Assert.Eq (Self.Tester.Aa_T_Recv_Sync_History.Get (Positive (Idx)), Data_A);"
  print "         Packed_Connector_Index_Assert.Eq (Self.Tester.Packed_Connector_Index_T_Recv_Sync_History.Get (Positive (Idx)), (Index => Idx));"
  print "      end loop;"
  print "      Self.Tester.Aa_T_Recv_Sync_History.Clear;"
  print "      Self.Tester.Packed_Connector_Index_T_Recv_Sync_History.Clear;"
  print "      for Idx in Self.Tester.Connector_Aa_T_Provide_2@Range loop"
  print "         Put_Line (\"Sending Aa_T_Provide_2 index \" & Natural@Image (Natural (Idx)));"
  print "         Self.Tester.Aa_T_Provide_2 (Idx, Data_A);"
  print "         Natural_Assert.Eq (Self.Tester.Packed_Connector_Index_T_Recv_Sync_History.Get_Count, Natural (Idx));"
  print "         Natural_Assert.Eq (Self.Tester.Aa_T_Recv_Sync_History.Get_Count, Natural (Idx));"
  print "         A_Assert.Eq (Self.Tester.Aa_T_Recv_Sync_History.Get (Positive (Idx)), Data_A);"
  print "         Packed_Connector_Index_Assert.Eq (Self.Tester.Packed_Connector_Index_T_Recv_Sync_History.Get (Positive (Idx)), (Index => Idx));"
  print "      end loop;"
  print "      Put_Line (\"passed.\");"
  print "      New_Line;"
  next
}
/Assert \(False/ {
  next
}

{
  print $0
}
' | tr "@" "'" | sed 's/-- Self.Tester.Init_Base/Self.Tester.Init_Base/g' | sed 's/=> TBD/=> 3/g' | sed 's/Queue_Size => 3/Queue_Size => 3 * Self.Tester.Component_Instance.Get_Max_Queue_Element_Size/g'
