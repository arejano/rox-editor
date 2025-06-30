Objetivos

1 - rox-ui: Uma lib de interface feita com Love2D para ser integrada ao editor e jogo
2 - rox-editor: 
3 - rox-ecs: ecs :)
4 - rox-profiller: Interface para debuggar o jogo durante a gameplay

### Planejado
- UiHandler - Ponto principal para o controle da UI, recebe as acoes via RoxEditor ou Jogo
  - RoxEditorUi
    - Validar se eh possivel incliuir controle para nao evitar a propagacao de eventos (precisa de redraw de toda a tree de elementos se o pai delas mudar)


### Concluido
- rox-ecs
  - completo
- rox-editor
  - Sistema principal que controla o render da interface baseado no status de cada elemento
  - Sistema que armazena os dados de cada elemento da interface e reage a mudancas caso o dado seja alterado
-

### Debitos Tecnicos da V1
- Abstracao do UIHandler para mentalidade de LIB
- Desacoplar o controle de interface em uma lib propria, como o rox-ecs
- Sistema de coleta de lixo para o uso de memoria
  - O canvas de cada componente pode ser lixo
  - Estudar a ideia de utilizar um buffer para os canvas, algo que pode ser liberado
