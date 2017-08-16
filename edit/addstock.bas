'This adds the given item to the given shop's wares if there is room.
' It will replace the first empty slot it encounters.

sub FF4Rom.AddStock(shop_index as UByte, item_index as UByte)

 for i as Integer = 1 to 8
  if shops(shop_index).wares(i) = &hFF then
   shops(shop_index).wares(i) = item_index
   exit for
  end if
 next

end sub
