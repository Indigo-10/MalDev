Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$gifUrls = @(
    'http://127.0.0.1:8000/cat-black-cat.gif'
)
$messages = @(
    'uh oh, looks like u have meowware :('
)

$randomGif = $gifUrls | Get-Random
$randomMessage = $messages | Get-Random

$catGifPath = "$env:TEMP\cat.gif"
(New-Object System.Net.WebClient).DownloadFile($randomGif, $catGifPath)

$form = New-Object Windows.Forms.Form
$form.Text = 'meowware.exe'
$form.Width = 400
$form.Height = 300
$form.StartPosition = 'CenterScreen'

$label = New-Object Windows.Forms.Label
$label.Text = $randomMessage
$label.AutoSize = $true
$label.Location = New-Object Drawing.Point(80, 10)
$form.Controls.Add($label)

$pictureBox = New-Object Windows.Forms.PictureBox
$pictureBox.Image = [System.Drawing.Image]::FromFile($catGifPath)
$pictureBox.SizeMode = 'StretchImage'
$pictureBox.Location = New-Object Drawing.Point(50, 50)
$pictureBox.Width = 300
$pictureBox.Height = 200
$form.Controls.Add($pictureBox)

$form.Topmost = $true
$form.Add_Shown({$form.Activate()})
$form.ShowDialog()
