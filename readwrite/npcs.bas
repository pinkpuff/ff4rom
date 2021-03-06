sub FF4Rom.ReadNPCs()

 dim start as Integer
 dim finish as Integer
 dim offset as Integer
 dim temp as UByte
 dim c as CallComponent ptr
 dim bytes as List
 
 c = callocate(SizeOf(CallComponent))
 
 for i as Integer = 0 to total_npcs

  npcs(i).sprite = ByteAt(&h97200 + i)
  if ByteAt(&h97400 + i \ 8) and 2 ^ (i mod 8) then
   npcs(i).visible = true
  else
   npcs(i).visible = false
  end if
  
  start = ByteAt(&h99A00 + 2 * i) + ByteAt(&h99A00 + 2 * i + 1) * &h100 + &h99E00
  finish = ByteAt(&h99A00 + 2 * (i + 1)) + ByteAt(&h99A00 + 2 * (i + 1) + 1) * &h100 + &h99E00
  offset = 0
  do while start + offset < finish
   temp = ByteAt(start + offset)
   offset += 1
   select case temp
    case &hFF
     c->event_index = ByteAt(start + offset)
     offset += 1
     c->false_conditions.Join(bytes)
     bytes.Destroy()
     npcs(i).speech.components.AddPointer(c)
     c = callocate(SizeOf(CallComponent))
    case &hFE
     c->true_conditions.AddValue(ByteAt(start + offset))
     offset += 1
    case else
     bytes.AddValue(temp)
   end select
  loop
  if bytes.Length() > 0 then
   npcs(i).speech.parameters.Join(bytes)
   bytes.Destroy()
  end if
  
 next
 
 deallocate(c)

end sub


sub FF4Rom.WriteNPCs()

 dim start as Integer
 dim offset as Integer
 dim temp as UByte
 dim c as CallComponent ptr

 for i as Integer = 0 to total_npcs
 
  WriteByte(&h97200 + i, npcs(i).sprite) 
  temp = ByteAt(&h97400 + i \ 8) 
  if npcs(i).visible then
   temp = temp or 2 ^ (i mod 8)
  else
   temp = temp and &hFF - 2 ^ (i mod 8)
  end if
  WriteByte(&h97400 + i \ 8, temp)
  
  start = ByteAt(&h99A00 + 2 * i) + ByteAt(&h99A00 + 2 * i + 1) * &h100 + &h99E00
  WriteByte(&h99A00 + 2 * i, (start - &h99E00) mod &h100)
  WriteByte(&h99A00 + 2 * i + 1, (start - &h99E00) \ &h100)
  for j as Integer = 1 to npcs(i).speech.components.Length()
   c = npcs(i).speech.components.PointerAt(j)
   for k as Integer = 1 to c->true_conditions.Length()
    WriteByte(start + offset, &hFE)
    WriteByte(start + offset + 1, c->true_conditions.ValueAt(k))
    offset += 2
   next
   for k as Integer = 1 to c->false_conditions.Length()
    WriteByte(start + offset, c->false_conditions.ValueAt(k))
    offset += 1
   next
   WriteByte(start + offset, &hFF)
   WriteByte(start + offset + 1, c->event_index)
   offset += 2
  next
  for j as Integer = 1 to npcs(i).speech.parameters.Length()
   WriteByte(start + offset, npcs(i).speech.parameters.ValueAt(j))
   offset += 1
  next
  start += offset
  offset = 0

 next

end sub
