'This sorts all the learned spells in each spell set by the level at which
' they're learned. If you make any changes to the spell learning sequence for
' any of the spell sets, you should run this before saving.

sub FF4Rom.SortSpellSets()

 dim bucket(99) as List
 dim new_levels as List
 dim new_spells as List
 
 for i as Integer = 0 to total_spell_sets
  
  new_levels.Destroy()
  new_spells.Destroy()
  for j as Integer = 1 to 99
   bucket(j).Destroy()
  next
  
  for j as Integer = 1 to spellsets(i).learning_levels.Length()
   bucket(asc(spellsets(i).learning_levels.ItemAt(j))).AddItem(spellsets(i).learning_spells.ItemAt(j))
  next
  
  for j as Integer = 1 to 99
   for k as Integer = 1 to bucket(j).Length()
    new_levels.AddItem(chr(j))
    new_spells.AddItem(bucket(j).ItemAt(k))
   next
  next
  
  spellsets(i).learning_levels.Destroy()
  spellsets(i).learning_spells.Destroy()
  for j as Integer = 1 to new_levels.Length()
   spellsets(i).learning_levels.AddItem(new_levels.ItemAt(j))
   spellsets(i).learning_spells.AddItem(new_spells.ItemAt(j))
  next
 
 next

end sub
