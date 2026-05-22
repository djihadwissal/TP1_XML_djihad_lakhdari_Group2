<?php
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $xmlFile = '../club.xml';
    $xml = simplexml_load_file($xmlFile);

    // استقبال البيانات المرسلة من النموذج
    $membreRef = $_POST['membreRef'];
    $concoursId = $_POST['concoursId'];
    $complexite = $_POST['complexite'];
    $tempsExecution = $_POST['tempsExecution'];

    // البحث عن المسابقة المطلوبة في ملف XML لإضافة المشارك داخلها
    foreach ($xml->concours->concours as $c) {
        if ((string)$c['id'] === $concoursId) {
            
            // إضافة العقدة <participant> مع الخاصية membreRef
            $participant = $c->participants->addChild('participant');
            $participant->addAttribute('membreRef', $membreRef);
            
            // إضافة العقد الفرعية للتعقيد ووقت التنفيذ
            $participant->addChild('complexite', $complexite);
            $participant->addChild('tempsExecution', $tempsExecution);
            
            break;
        }
    }

    // حفظ التعديلات في ملف XML
    if ($xml->asXML($xmlFile)) {
        echo "<script>alert('تم تسجيل المشارك بنجاح في المسابقة!'); window.location.href='index.php';</script>";
    } else {
        echo "<script>alert('حدث خطأ أثناء حفظ البيانات.'); window.history.back();</script>";
    }
}
?>