with Checksum_16; use Checksum_16;
with Basic_Types.Representation; use Basic_Types;

procedure Test is
   Checksum : Checksum_16_Type;
begin
   Checksum := Compute_Checksum_16 ([0, 1, 2, 3, 4, 5, 6, 7, 8, 9]);
   pragma Assert (Checksum = [16#14#, 16#19#], "Expected " & Basic_Types.Representation.To_Tuple_String ([16#14#, 16#19#]) & " and got " & Basic_Types.Representation.To_Tuple_String (Checksum));
   Checksum := Compute_Checksum_16 ([1 => 0, 2 => 1, 3 => 2, 4 => 3, 5 => 4, 6 => 5, 7 => 6, 8 => 7, 9 => 8, 10 => 9]);
   pragma Assert (Checksum = [16#14#, 16#19#], "Expected " & Basic_Types.Representation.To_Tuple_String ([16#14#, 16#19#]) & " and got " & Basic_Types.Representation.To_Tuple_String (Checksum));
   Checksum := Compute_Checksum_16 ([255, 1, 2, 10, 4, 15, 6, 0, 254, 9], Seed => [0, 11]);
   pragma Assert (Checksum = [16#09#, 16#2E#], "Expected " & Basic_Types.Representation.To_Tuple_String ([16#09#, 16#2E#]) & " and got " & Basic_Types.Representation.To_Tuple_String (Checksum));
   Checksum := Compute_Checksum_16 ([255, 1, 2, 10, 4, 15, 6, 0, 254], Seed => [0, 11]);
   pragma Assert (Checksum = [16#09#, 16#25#], "Expected " & Basic_Types.Representation.To_Tuple_String ([16#09#, 16#25#]) & " and got " & Basic_Types.Representation.To_Tuple_String (Checksum));
   Checksum := Compute_Checksum_16 ([255, 1, 2, 10, 4, 15, 6, 0, 254]);
   pragma Assert (Checksum = [16#09#, 16#1A#], "Expected " & Basic_Types.Representation.To_Tuple_String ([16#09#, 16#1A#]) & " and got " & Basic_Types.Representation.To_Tuple_String (Checksum));
   Checksum := Compute_Checksum_16 ([
      16#1B#,
      16#78#,
      16#C3#,
      16#CE#,
      16#00#,
      16#A1#,
      16#4E#,
      16#57#,
      16#F6#,
      16#C1#,
      16#7E#,
      16#4A#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#08#,
      16#64#,
      16#C1#,
      16#E6#,
      16#00#,
      16#8E#,
      16#4E#,
      16#57#,
      16#F6#,
      16#C0#,
      16#D5#,
      16#B3#,
      16#08#,
      16#32#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#00#,
      16#C0#,
      16#C0#,
      16#00#,
      16#98#,
      16#93#,
      16#08#
   ]);
   pragma Assert (Checksum = [16#E5#, 16#7D#], "Expected " & Basic_Types.Representation.To_Tuple_String ([16#E5#, 16#7D#]) & " and got " & Basic_Types.Representation.To_Tuple_String (Checksum));
end Test;
