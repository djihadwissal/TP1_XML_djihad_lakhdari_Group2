(: 1. Insertion : Ajouter un nouveau membre :)
(: إضافة عضو جديد مستوفٍ للشروط وبمعرف فريد غير مستخدم إلى عقدة membres :)
insert node 
  <membre id="M009" categorieRef="C2">
    <nom>Zerrouk</nom>
    <prenom>Lyna</prenom>
    <email>l.zerrouk@club.dz</email>
  </membre>
into doc("club.xml")//membres;

(: 2. Modification : Changer le coefficient du concours CO2 :)
(: تعديل قيمة المعامل للمسابقة CO2 وتحديثها مباشرة في عقدة البيانات :)
replace value of node doc("club.xml")//concours[@id="CO2"]/@coefficient with "2.0";

(: 3. Suppression : Supprimer un participant précis d'un concours donné :)
(: حذف مشارك معين بناءً على معرفه دون التأثير على بنية المسابقة الأصلية :)
delete node doc("club.xml")//concours[@id="CO1"]//participant[@membreRef="M007"];