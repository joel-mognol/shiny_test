#library(readr)
library(tidyr)
library(dplyr)
library(ggplot2)

#choix du prénom. A changer ici pour les tests subséquents.
prenomchoisi <- toupper('edith')

#limitation de la liste aux stats du prénom choisi à partir de nat2018l et nat2018w
choix2018l <- nat2018l %>%
  filter(preusuel==prenomchoisi)
choix2018w <- nat2018w %>%
  filter(preusuel==prenomchoisi)

choix2018l2 <- choix2018w %>%
  pivot_longer(cols = c(homme,femme), names_to = "sexe", values_to = "nombre") %>%
  select(sexe,preusuel,annais,nombre)
choix2018l2$sexe <- ifelse(choix2018l2$sexe == "homme", "1", "2")

#test de pseudo pyramide des âges, adapté de https://stackoverflow.com/a/36804394
ggplot(data = choix2018l2,
       mapping = aes(x = annais,
                     y = ifelse(test = sexe == "1", yes = -nombre, no = nombre),
                     fill = sexe)) +
  geom_col() +
  scale_fill_manual(values = c("#109CEF", "#EF109C"),labels=c("Hommes", "Femmes")) +
  theme(legend.position="bottom") +
  coord_flip() +
  scale_y_continuous(labels = abs, limits = max(choix2018l$nombre) * c(-1,1)) +
  labs(x="Année de naissance",y = "Nombre") +
  labs(title=paste("Répartition des personnes appelées",prenomchoisi), subtitle="Source : Insee d'après les déclarations à l'état civil français")


##test des graphs avec barplot
#prénoms masculins et féminins ensemble (l'un après l'autre)
barplot(choix2018l$nombre,
        names.arg = choix2018l$annais,
        border = NA,
        main = paste("Occurence du prénom ",prenomchoisi),
        xlab = "Année de naissance",
        ylab = "Nombre",
        las=2,
        cex.names=0.8)
#prénoms masculins seuls
barplot(choix2018w$homme,
        names.arg = choix2018w$annais,
        border = NA,
        main = paste("Occurence du prénom masculin ",prenomchoisi),
        xlab = "Année de naissance",
        ylab = "Nombre",
        las=2,
        cex.names=0.8)
#prénoms féminins seuls
barplot(choix2018w$femme,
        names.arg = choix2018w$annais,
        border = NA,
        main = paste("Occurence du prénom féminin ",prenomchoisi),
        xlab = "Année de naissance",
        ylab = "Nombre",
        las=2,
        cex.names=0.8)

#tentative d'afficher les deux en parallèle en mettant les chiffres des femmes en négatif
barplot(rbind(choix2018w$homme, -choix2018w$femme),
        main=paste("Occurence des ",prenomchoisi," homme ou femme"),
        xlab="Année de naissance",
        col=c("cyan","red"),
        names.arg = choix2018w$annais,
        beside = TRUE,
        horiz=FALSE,
        border=NA)


##test des graphs avec ggplot
#exemple simple avec les stats des hommes seuls
ggplot(choix2018w, aes(x=annais,y=homme)) +
  geom_bar(stat="identity")

#affichage des stats des deux sexes empilées
ggplot(choix2018l, aes(fill=sexe,y=nombre,x=annais)) +
  geom_bar(stat="identity",position="stack")

# Stacked Bar Plot with Colors and Legend (code glané sur Internet)
counts <- table(mtcars$vs, mtcars$gear)
barplot(counts, main="Car Distribution by Gears and VS",
        xlab="Number of Gears", col=c("darkblue","red"),
        legend = rownames(counts))