<?php
// 1. تحميل ملف XML
$xmlFile = '../club.xml';

if (!file_exists($xmlFile)) {
    die("خطأ: ملف club.xml غير موجود!");
}

$xml = simplexml_load_file($xmlFile);
?>
<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
    <meta charset="UTF-8">
    <title>إدارة نادي Info_Tech</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

    <header>
        <h1>لوحة تحكم نادي Info_Tech</h1>
    </header>

    <main class="container">
        
        <section class="card">
            <h2>🏆 المسابقات المتاحة</h2>
            <table>
                <thead>
                    <tr>
                        <th>المسابقة</th>
                        <th>التاريخ</th>
                        <th>المعامل</th>
                        <th>الفئة المستهدفة</th>
                    </tr>
                </thead>
                <tbody>
                    <?php
                    // نمر على كل مسابقة في ملف الـ XML
                    foreach ($xml->concours->concours as $c) {
                        // جلب اسم الفئة المطابقة عبر المعرف categorieRef
                        $catRef = (string)$c['categorieRef'];
                        $categorieLabel = "";
                        foreach ($xml->categories->categorie as $cat) {
                            if ((string)$cat['id'] == $catRef) {
                                $categorieLabel = (string)$cat['libelle'];
                                break;
                            }
                        }
                        
                        echo "<tr>";
                        echo "<td>" . htmlspecialchars($c->titre) . "</td>";
                        echo "<td>" . htmlspecialchars($c['date']) . "</td>";
                        echo "<td>" . htmlspecialchars($c['coefficient']) . "</td>";
                        echo "<td>" . htmlspecialchars($categorieLabel) . "</td>";
                        echo "</tr>";
                    }
                    ?>
                </tbody>
            </table>
        </section>

        <section class="card">
            <h2>📝 تسجيل عضو في مسابقة</h2>
            <form action="inscrire.php" method="POST">
                <div class="form-group">
                    <label for="membre">اختر العضو:</label>
                    <select name="membreRef" id="membre" required>
                        <?php
                        foreach ($xml->membres->membre as $m) {
                            echo "<option value='{$m['id']}'>{$m->prenom} {$m->nom} ({$m['id']})</option>";
                        }
                        ?>
                    </select>
                </div>

                <div class="form-group">
                    <label for="concours">اختر المسابقة:</label>
                    <select name="concoursId" id="concours" required>
                        <?php
                        foreach ($xml->concours->concours as $c) {
                            echo "<option value='{$c['id']}'>{$c->titre}</option>";
                        }
                        ?>
                    </select>
                </div>

                <div class="form-group">
                    <label for="complexite">درجة التعقيد (0-100):</label>
                    <input type="number" name="complexite" id="complexite" min="0" max="100" required>
                </div>

                <div class="form-group">
                    <label for="temps">وقت التنفيذ (بالملي ثانية):</label>
                    <input type="number" name="tempsExecution" id="temps" min="1" required>
                </div>

                <button type="submit" class="btn">تأكيد التسجيل</button>
            </form>
        </section>

    </main>

</body>
</html>