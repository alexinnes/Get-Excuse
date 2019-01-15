

$inputXML = @"
<Window x:Name="Main" x:Class="getExcuse.MainWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Generate an Excuse" Height="350" Width="794">
    <Grid>
        <Label x:Name="Label" Content="" Margin="10,74,10,162" FontSize="16" FontWeight="Bold" HorizontalContentAlignment="Center"/>
        <Button x:Name="button" Content="Generate Excuse" Margin="158,0,152,26" Height="43" VerticalAlignment="Bottom" ToolTip="Click me to generate an excuse"/>

    </Grid>
</Window>
"@

$inputXML = $inputXML -replace 'mc:Ignorable="d"','' -replace "x:N",'N'  -replace '^<Win.*', '<Window'

[void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')
[xml]$XAML = $inputXML
#Read XAML

$reader = (New-Object System.Xml.XmlNodeReader $xaml)
try{
    $Form = [Windows.Markup.XamlReader]::Load( $reader )
}
catch{
    Write-Warning "Unable to load Windows.Markup.XamlReader. Double-check syntax and ensure .net is installed."
}


$xaml.SelectNodes("//*[@Name]") | foreach{Set-Variable -Name "WPF_$($_.Name)" -Value $Form.FindName($_.Name)}
If(!$excuses){
    $Global:Excuses = (Invoke-WebRequest http://pages.cs.wisc.edu/~ballard/bofh/excuses).Content.Split([Environment]::NewLine)
}


$WPF_button.Add_Click({
    $WPF_Label.Content = $global:excuses[(get-random $excuses.count)]
})

$Form.ShowDialog() | out-null


