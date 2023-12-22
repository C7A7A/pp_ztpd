let $collection := collection("db/shakespeare")

(: 20 :)
(:
let $plays := collection("db/shakespeare")//PLAY
return
  <wynik>
  {
    for $play in $plays
    return
      <TITLE>{$play/TITLE/text()}</TITLE>
  }
  </wynik>
:)

(: 21 :)
(:
for $plays in $collection//PLAY[.//LINE[contains(., "or not to be")]]
return 
    <TITLE>
      {$plays/TITLE/text()}
    </TITLE>
:)

(: 22 :)
for $plays in $collection//PLAY
let $characters := count($plays//PERSONA)
let $acts := count($plays//ACT)
let $scenes := count($plays//SCENE)
return
  <wynik>
    {
      <sztuka tytul="{$plays/TITLE/text()}">
        <postaci>{$characters}</postaci>
        <aktow>{$acts}</aktow>
        <scen>{$scenes}</scen>
      </sztuka>
    }
  </wynik>



