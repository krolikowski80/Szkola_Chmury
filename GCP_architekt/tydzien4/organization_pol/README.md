# [Cloud Organization Policy Service and Constraints](https://szkolachmury.pl/google-cloud-platform-droga-architekta/tydzien-4-cloud-identity-and-access-management/cloud-organization-policy-service-and-constraints/)

* [Managing Organization Policies](https://cloud.google.com/resource-manager/docs/organization-policy/creating-managing-policies)

```bash
#Lista dostępnych projektów
gcloud projects list

#Wyświetl bieżące zasady „compute.trustedImageProjects” dla projektu
gcloud beta resource-manager org-policies describe compute.trustedImageProjects \
--effective  \
--project <PROJECT_ID>

#Przygotuj pliki konfiguracyjne zasad
gcloud beta resource-manager org-policies describe compute.trustedImageProjects \
--effective  \
--project <PROJECT_ID> > file1policy.yaml

#Backup jeszcze nikomu krzywdy nie zrobił
gcloud beta resource-manager org-policies describe compute.trustedImageProjects --effective  --project <PROJECT_ID> > file1restore.yaml

#Uzyskaj dostępną listę obrazów
gcloud compute images list

#Zmodyfikuj istniejącą politykę - file1policy.yaml - aby odmówić wybranym obrazom
constraint: constraints/compute.trustedImageProjects
listPolicy:
deniedValues:
- projects/debian-cloud

# Zaktualizuj zasady w wybranym projekcie
gcloud beta resource-manager org-policies set-policy \
--project <PROJECT_ID> file1policy.yaml


# Przywróć domyślne zasady w projekcie 
gcloud beta resource-manager org-policies set-policy \
--project <PROJECT_ID> file1restore.yaml
```