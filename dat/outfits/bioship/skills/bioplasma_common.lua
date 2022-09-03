-- Need to set effect_name before requiring
-- luacheck: globals effect_name
local fmt = require "format"

local damage, penetration, isturret
function onload( o )
   local s     = o:specificstats()
   damage      = s.damage
   penetration = s.penetration
   isturret    = s.isturret
end

local mapping = {
   ["Corrosion I"] = "corrosion_i",
   ["Paralyzing Plasma"] = "paralyzing",
   ["Crippling Plasma"] = "crippling",
   ["Corrosion II"] = "corrosion_ii",
}
function init( p, _po )
   for k,o in ipairs(p:outfitsList("intrinsic")) do
      local m = mapping[ o:nameRaw() ]
      if m then
         mem[m] = true
      end
   end
end

function descextra( _p )
   return fmt.f(_("Plasma burns deal an extra {damage:.1f} of damage over 5 seconds on the target."),{damage=damage})
end

function onimpact( p, target )
   local ts = target:stats()
   local dmg = damage * (1 - math.min( 1, math.max( 0, ts.absorb - penetration ) ))

   -- Modify by damage
   if p:exists() then
      local mod
      if isturret then
         mod = p:shipstat("tur_damage",true)
      else
         mod = p:shipstat("fwd_damage",true)
      end
      dmg = dmg * mod
   end

   if mem.corrosion_ii then
      target:effectAdd( effect_name, 10, dmg )
      target:effectAdd( "Paralyzing Plasma", 10 )
      target:effectAdd( "Crippling Plasma", 10 )
   elseif mem.corrosion_i then
      target:effectAdd( effect_name, 7.5, dmg )
      if mem.paralyzing then
         target:effectAdd( "Paralyzing Plasma", 7.5 )
      end
      if mem.crippling then
         target:effectAdd( "Crippling Plasma", 7.5 )
      end
   else
      target:effectAdd( effect_name, 5, dmg )
   end
end
