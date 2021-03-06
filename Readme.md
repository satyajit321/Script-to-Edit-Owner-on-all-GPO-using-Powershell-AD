<div><strong>Description:</strong></div>
<div>This script will replace all of the GPOs' Owner with&nbsp; "Domain Admins" security group. This would help incases where you want to modify multiple Group Policy Object owner information. Maybe due to old stale SID mapped of some deleted user or you want  to change similar naming GPOs to some other Group etc.</div>
<div>This script allows you to change ALL GPOs or selective GPOs with Owner of your choice.</div>
<div></div>
<div><strong>EXAMPLE\USAGE</strong><br /> Change the Names of the Owner and GPO filter you need</div>
<div></div>
<div>$OwnerNew = "Domain Admins" #Name of the Object user or group to be updated<br /> $GPOName = "TestGPO*" #GPO to be updated, This field accepts wildcards,&nbsp; "*" updates all GPO</div>
<div></div>
<div>Run "Change GPO Owner using AD DACL.ps1" in EMS</div>
<div><strong>&nbsp;</strong></div>
<div><strong>Sample Script Run and Output:</strong></div>
<div>Change GPO Owner using AD DACL.ps1</div>
<div><strong>
<div class="scriptcode">
<div class="pluginEditHolder" pluginCommand="mceScriptCode">
<div class="title"><span>Bash/shell</span></div>
<div class="pluginLinkHolder"><span class="pluginEditHolderLink">Edit</span>|<span class="pluginRemoveHolderLink">Remove</span></div>
<span class="hidden">bash</span>
<pre class="hidden">PS C:\Users\Administrator&gt; C:\Users\Administrator\Desktop\ChangeGPO-Owner.ps1

GPO Name           OwnerBefore                      OwnerAfter
--------           -----------                      ----------
TestGPO2           BLUEBELL\Domain Admins           BLUEBELL\User1_
TestGPO1           BLUEBELL\Domain Admins           BLUEBELL\User1_

PS C:\Users\Administrator&gt; C:\Users\Administrator\Desktop\ChangeGPO-Owner.ps1

GPO Name           OwnerBefore                      OwnerAfter
--------           -----------                      ----------
TestGPO2           BLUEBELL\User1_           BLUEBELL\Domain Admins
TestGPO1           BLUEBELL\User1_           BLUEBELL\Domain Admins

PS C:\Users\Administrator&gt; </pre>
<div class="preview">
<pre class="bash"><span class="bash__commands">PS</span> C:\<span class="bash__commands">Users</span>\Administrator&gt; C:\<span class="bash__commands">Users</span>\Administrator\Desktop\ChangeGPO-Owner.ps1 
 
GPO Name           OwnerBefore                      OwnerAfter 
--------           -----------                      ---------- 
TestGPO2           BLUEBELL\Domain Admins           BLUEBELL\User1_ 
TestGPO1           BLUEBELL\Domain Admins           BLUEBELL\User1_ 
 
<span class="bash__commands">PS</span> C:\<span class="bash__commands">Users</span>\Administrator&gt; C:\<span class="bash__commands">Users</span>\Administrator\Desktop\ChangeGPO-Owner.ps1 
 
GPO Name           OwnerBefore                      OwnerAfter 
--------           -----------                      ---------- 
TestGPO2           BLUEBELL\User1_           BLUEBELL\Domain Admins 
TestGPO1           BLUEBELL\User1_           BLUEBELL\Domain Admins 
 
<span class="bash__commands">PS</span> C:\<span class="bash__commands">Users</span>\Administrator&gt; </pre>
</div>
</div>
</div>
</strong></div>
<div><strong>Script Sections that can be used independently</strong></div>
<div><strong><strong>&nbsp;</strong></strong></div>
<div></div>
<div>First lets find the GPO to be modified:</div>
<div>Get-GPO doesn't accept wildcards, and if there is an amiguity\duplicate in the GPOName it will throw error.</div>
<div><strong><strong>
<div class="scriptcode">
<div class="pluginEditHolder" pluginCommand="mceScriptCode">
<div class="title"><span>PowerShell</span></div>
<div class="pluginLinkHolder"><span class="pluginEditHolderLink">Edit</span>|<span class="pluginRemoveHolderLink">Remove</span></div>
<span class="hidden">powershell</span>
<pre class="hidden">Get-GPO TestGPO
 
DisplayName      : TestGPO
 
DomainName       : contoso.local
 
Owner            : CONTOSO\User1
 
Id               : 590f3e84-f967-45c6-bff2-03f7dc3f4f86
 
GpoStatus        : AllSettingsDisabled</pre>
<div class="preview">
<pre class="powershell">Get<span class="powerShell__operator">-</span>GPO TestGPO 
  
DisplayName      : TestGPO 
  
DomainName       : contoso.local 
  
Owner            : CONTOSO\User1 
  
Id               : 590f3e84<span class="powerShell__operator">-</span>f967<span class="powerShell__operator">-</span>45c6<span class="powerShell__operator">-</span>bff2<span class="powerShell__operator">-</span>03f7dc3f4f86 
  
GpoStatus        : AllSettingsDisabled</pre>
</div>
</div>
</div>
</strong></strong>
<div class="endscriptcode">
<div class="endscriptcode">Now using the GUID from earlier cmdlet we will get hold of the GPO Object on AD:</div>
</div>
<strong><strong>
<div class="endscriptcode">
<div class="endscriptcode">
<div class="scriptcode">
<div class="pluginEditHolder" pluginCommand="mceScriptCode">
<div class="title"><span>PowerShell</span></div>
<div class="pluginLinkHolder"><span class="pluginEditHolderLink">Edit</span>|<span class="pluginRemoveHolderLink">Remove</span></div>
<span class="hidden">powershell</span>
<pre class="hidden">Get-ADObject -Filter {Name -like "*590f3e84-f967-45c6-bff2-03f7dc3f4f86*"} | fl
 
DistinguishedName : CN={590F3E84-F967-45C6-BFF2-03F7DC3F4F86},CN=Policies,CN=System,DC=CONTOSO,DC=local
 
Name              : {590F3E84-F967-45C6-BFF2-03F7DC3F4F86}
 
ObjectClass       : groupPolicyContainer
 
ObjectGUID        : 56ee8095-8e66-4f92-845d-0e086fcc1ec2</pre>
<div class="preview">
<pre class="powershell">Get<span class="powerShell__operator">-</span>ADObject <span class="powerShell__operator">-</span><span class="powerShell__keyword">Filter</span> {Name <span class="powerShell__operator">-</span>like <span class="powerShell__string">"*590f3e84-f967-45c6-bff2-03f7dc3f4f86*"</span>} <span class="powerShell__operator">|</span><span class="powerShell__alias">fl</span> 
  
DistinguishedName : CN={590F3E84<span class="powerShell__operator">-</span>F967<span class="powerShell__operator">-</span>45C6<span class="powerShell__operator">-</span>BFF2<span class="powerShell__operator">-</span>03F7DC3F4F86},CN=Policies,CN=System,DC=CONTOSO,DC=local 
  
Name              : {590F3E84<span class="powerShell__operator">-</span>F967<span class="powerShell__operator">-</span>45C6<span class="powerShell__operator">-</span>BFF2<span class="powerShell__operator">-</span>03F7DC3F4F86} 
  
ObjectClass       : groupPolicyContainer 
  
ObjectGUID        : 56ee8095<span class="powerShell__operator">-</span>8e66<span class="powerShell__operator">-</span>4f92<span class="powerShell__operator">-</span>845d<span class="powerShell__operator">-</span>0e086fcc1ec2</pre>
</div>
</div>
</div>
</div>
</div>
</strong></strong></div>
<div><strong><strong>&nbsp;</strong></strong></div>
<div>Easier or user friendly way:</div>
<div>You can use Wildcard in this case on the GPOName using the where (?) filter. Running this prior to the script will tell you what to expect to be changed.</div>
<div></div>
<div>
<div class="scriptcode">
<div class="pluginEditHolder" pluginCommand="mceScriptCode">
<div class="title"><span>PowerShell</span></div>
<div class="pluginLinkHolder"><span class="pluginEditHolderLink">Edit</span>|<span class="pluginRemoveHolderLink">Remove</span></div>
<span class="hidden">powershell</span>
<pre class="hidden">Get-GPO -All | ?{$_.DisplayName -like "*GPOName*"}</pre>
<div class="preview">
<pre class="powershell">Get<span class="powerShell__operator">-</span>GPO <span class="powerShell__operator">-</span>All <span class="powerShell__operator">|</span> ?{<span class="powerShell__variable">$_</span>.DisplayName <span class="powerShell__operator">-</span>like <span class="powerShell__string">"*GPOName*"</span>}</pre>
</div>
</div>
</div>
<div class="endscriptcode"><strong>What is happening here is as good as the below GUI manual steps, but automatically in a few seconds:</strong></div>
<div class="endscriptcode"></div>
<div class="endscriptcode">
<p>*If we now open DSA.MSC and browse to that location contoso.local\System\Policies\</p>
<ul>
<li>Here all the GPOs will be listed. </li>
<li>If we go to the GUID and Rt. Click -&gt;Properties -&gt;Security Tab-&gt;Advanced Button </li>
<li>We get the 'Advanced Security Settings for GUID', and Owner: CONTOSO\User1 can be changed here. </li>
</ul>
<p>*If we now start from GPMC.msc</p>
<ul>
<li><span style="color: #2a2a2a; line-height: 125%; font-family: &quot;Segoe UI&quot;,&quot;sans-serif&quot;; font-size: 10pt;">Run<strong>gpmc.msc</strong>, select your group policy, go to <strong>Delegation</strong>and then click on<strong>Advanced</strong> </span></li>
<li><span style="color: #2a2a2a; line-height: 125%; font-family: &quot;Segoe UI&quot;,&quot;sans-serif&quot;; font-size: 10pt;">Click on<strong>Advanced </strong>and then select <strong>Owner</strong> </span></li>
<li><span style="color: #2a2a2a; line-height: 125%; font-family: &quot;Segoe UI&quot;,&quot;sans-serif&quot;; font-size: 10pt;">Add your user/group and then click on<strong>Apply</strong> </span></li>
</ul>
<p>If you have noticed this brings up the exact same 'Advanced Security Settings for GUID' screen in both cases, basically indicating this has someting to do with DACL for Active Directory.</p>
<p>&nbsp;</p>
</div>
</div>
<div><strong><strong>&nbsp;</strong></strong></div>
<div><strong><strong>Referenes:</strong></strong></div>
<div><span><a href="https://social.technet.microsoft.com/Forums/en-US/a2e4d5f9-ad8e-4d1f-8f60-98039d5e2f46/edit-owner-on-a-gpo-using-powershell?forum=ITCG">Edit Owner on a GPO using Powershell</a></span></div>
<div><a href="http://rakhesh.com/powershell/using-get-acl-to-view-and-modify-access-control-lists-part-1/" target="_blank">Using Get-ACL to view and modify Access Control Lists</a></div>
<div><a href="http://blogs.technet.com/b/heyscriptingguy/archive/2008/04/15/how-can-i-use-windows-powershell-to-determine-the-owner-of-a-file.aspx" target="_blank">Hey, Scripting Guy! How Can I Use Windows PowerShell to Determine the Owner of a File?</a></div>
<div><a href="http://blogs.technet.com/b/joec/archive/2013/04/25/active-directory-delegation-via-powershell.aspx" target="_blank">Active Directory Delegation via PowerShell</a></div>
<div><a href="/questions/26543127/powershell-setting-advanced-ntfs-permissions">PowerShell Setting advanced NTFS permissions</a></div>
<div><strong>&nbsp;</strong></div>
<div><strong>&nbsp;</strong></div>
<div><strong>&nbsp;</strong></div>
<div><strong>&nbsp;</strong></div>
<div><strong>&nbsp;</strong></div>
<div><strong>&nbsp;</strong></div>
<div><strong>&nbsp;</strong></div>
<div><strong>&nbsp;</strong></div>
<div><strong>&nbsp;</strong></div>
<div><strong>&nbsp;</strong></div>
