function UIElement:manageMemory()
  -- Para elementos fora da tela/inativos
  if not self.visible or self.alpha == 0 then
    if self.canvas then
      self.canvas:release()
      self.canvas = nil
      self.dirty = true -- Força rerrenderização quando voltar
    end
  end

  -- Para elementos que não mudam há muito tempo
  if not self.dirty and self.timeSinceLastRender > 60 then
    self:freeResources()
  end

  -- Propaga para filhos
  for _, child in ipairs(self.childs) do
    child:manageMemory()
  end
end

function UIElement:freeResources()
  if self.canvas then
    self.canvas:release()
  end

  for _, child in ipairs(self.childs) do
    child:freeResources()
  end
end

