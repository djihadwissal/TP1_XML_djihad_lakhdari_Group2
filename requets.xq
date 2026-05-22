(: Q1: Liste complète des membres avec les libellés de leurs catégories :)
(: نمر على كل عضو، ونقوم بجلب اسم فئته عبر ربط الـ idRef ثم نحدد صيغة الخرج المطلوبة :)
<membres>
{
  for $m in //membre
  let $cat := //categorie[@id = $m/@categorieRef]
  return
    <membre id="{$m/@id}">
      <nomComplet>{concat($m/prenom, ' ', $m/nom)}</nomComplet>
      <email>{data($m/email)}</email>
      <categorie>{data($cat/@libelle)}</categorie>
    </membre>
}
</membres>;

(: Q2: Liste des concours organisés triés par date croissante :)
(: نمر على كل المسابقات، نجلب اسم الفئة الخاصة بها، ثم نرتبها تصاعدياً حسب التاريخ :)
<concours_liste>
{
  for $c in //concours/concours
  let $cat := //categorie[@id = $c/@categorieRef]
  order by $c/@date ascending
  return
    <concours id="{$c/@id}">
      <titre>{data($c/titre)}</titre>
      <date>{data($c/@date)}</date>
      <coefficient>{data($c/@coefficient)}</coefficient>
      <categorie>{data($cat/@libelle)}</categorie>
    </concours>
}
</concours_liste>;

(: Q3: Calcul du score de chaque participant arrondi à 2 décimales :)
(: نمر على المسابقات ثم على المشاركين داخلها ونطبق الصيغة الرياضية المطلوبة مع تقريب النتيجة :)
<scores>
{
  for $c in //concours/concours
  for $p in $c/participants/participant
  let $m := //membre[@id = $p/@membreRef]
  let $calc_score := round((($p/complexite + $p/tempsExecution) * $c/@coefficient), 2)
  return
    <participation>
      <concoursTitre>{data($c/titre)}</concoursTitre>
      <nomParticipant>{concat($m/prenom, ' ', $m/nom)}</nomParticipant>
      <complexite>{data($p/complexite)}</complexite>
      <tempsExecution>{data($p/tempsExecution)}</tempsExecution>
      <score>{$calc_score}</score>
    </participation>
}
</scores>;

(: Q4: Vainqueur de chaque concours (gère aussi les ex-aequo) :)
(: لكل مسابقة، نحسب أولاً القيمة القصوى للمجموع، ثم نفلتر المشارك الذي يملك هذا المجموع الأقصى :)
<vainqueurs>
{
  for $c in //concours/concours
  (: حساب النقاط لجميع المشاركين في المسابقة الحالية لتحديد النتيجة القصوى :)
  let $scores := for $p in $c/participants/participant return ($p/complexite + $p/tempsExecution) * $c/@coefficient
  let $max_score := max($scores)
  return
    <concours id="{$c/@id}" titre="{$c/titre}">
    {
      for $p in $c/participants/participant
      let $current_score := ($p/complexite + $p/tempsExecution) * $c/@coefficient
      where $current_score = $max_score
      let $m := //membre[@id = $p/@membreRef]
      return
        <gagnant>
          <nom>{data($m/nom)}</nom>
          <prenom>{data($m/prenom)}</prenom>
          <score>{round($current_score, 2)}</score>
        </gagnant>
    }
    </concours>
}
</vainqueurs>;

(: Q5: Membres d'une catégorie spécifique triés par nom puis prénom :)
(: استخدام متغير خارجي لفلترة الأعضاء حسب اسم الفئة ومن ثم ترتيبهم أبجدياً :)
declare variable $categorie as xs:string := "Intelligence Artificielle";

<membres_par_categorie categorie="{$categorie}">
{
  for $m in //membre
  let $cat := //categorie[@id = $m/@categorieRef]
  where $cat/@libelle = $categorie
  order by $m/nom ascending, $m/prenom ascending
  return
    <membre id="{$m/@id}">
      <nom>{data($m/nom)}</nom>
      <prenom>{data($m/prenom)}</prenom>
    </membre>
}
</membres_par_categorie>;