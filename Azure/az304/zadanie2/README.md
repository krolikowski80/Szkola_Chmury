> 1: Wykorzystaj Azure Firewall do ustawienia połączeń RDP z Internetu do maszyny po prywatnej adresacji

> 2: Utwórz konto składowania danych. 
Upewnij się, że ruch do konta składowania danych odbywa się tylko z wskazanej sieci i wykorzystuje prywatny adres IP. 
Pokaż, że faktycznie tak się dzieje.

> 3: Utwórz maszynę z Mikrotik. W ramach dostępów masz dostępną Image Gallery w subskrypcji AZ304s4, w której jest przygotowany obraz dla Mikrotik. Maszyna powinna mieć dwa interfejsy, ten który jest wystawiony na Świat (z public IP) i ten, który jest wystawiony do pracy z usługami „backend” - Twoimi maszynami. 
Skonfiguruj ruch z innej podsieci tak, by wychodził do Internetu przez Firewall opartego o Mikrotik. Do konfiguracji Mikrotik
