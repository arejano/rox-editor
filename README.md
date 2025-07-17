Objetivos

1 - rox-ui: Uma lib de interface feita com Love2D para ser integrada ao editor e jogo
2 - rox-editor: 
3 - rox-ecs: ecs :)
4 - rox-profiller: Interface para debuggar o jogo durante a gameplay

### Planejado
[x] - UiHandler - Ponto principal para o controle da UI, recebe as acoes via RoxEditor ou Jogo
  [ ] Validar se eh possivel incliuir controle para nao evitar a propagacao de eventos (precisa de redraw de toda a tree de elementos se o pai delas mudar)
[x] EventManager (receber dos componentes eventos que devem ser enviador para o Editor/Game/Interface)
[x] UIElement: Todo elemento em tela deve ser um UIElement
  - caracteristicas
    [x] elemento em tela deve ter um ID
    [x] redimensionar
    . recolher (efeito de exibir apenas a parra de titulo do elemento, se o elemento nao possui barra de titulo, ele nao pode ser recolhido)
    . minimizar (enviar a janela para o local de items minimizados)
    . auto-destruir
      [x] vertical
      . horizontal
-


### Concluido
- Abstracao do UIHandler para mentalidade de LIB
- Desacoplar o controle de interface em uma lib propria, como o rox-ecs
-- rox-ecs
  - completo
- rox-editor
  - Sistema principal que controla o render da interface baseado no status de cada elemento
  - Sistema que armazena os dados de cada elemento da interface e reage a mudancas caso o dado seja alterado
-

### Debitos Tecnicos da V1
 Sistema de coleta de lixo para o uso de memoria
  - O canvas de cada componente pode ser lixo
  - Estudar a ideia de utilizar um buffer para os canvas, algo que pode ser liberado
