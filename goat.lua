local framework = {
    show_menu = true,
    render = true,
    draw = false,
    x = 100,
    y = 100,
    width = 730,
    height = 540,
    drag = {
        is_dragging = false,
        offset_x = 0,
        offset_y = 0
    },
    vars = {
        cooldown = {},
        selected_tab = "Jogador",
        selected_subtab = "",
        active_groupbox = {},
        keybind = 157 -- 1
    },
    static_y = {
        tabs = 0,
        subtabs = 0,
    },
    fonts = {
        font_awesome = GoatAPI.Fonts.CreateFontAwesome(),
    },
    images = {
        -- goatLogo = GoatAPI.Images.ImportImageFromUrl("goatLogo", "https://cdn.discordapp.com/attachments/1285715927274618911/1286808419482861668/imatfthtfhtfhfthge-removebg-preview.png?ex=66ef413a&is=66edefba&hm=aec174fae9dd12cb58065b48ef3c92676ecc2a08f02cca06cc28314564714453&"),
    },
    colors = {
        theme = { 220, 220, 220 },
    },
    animations = {
        tab = {},
        subtab = {},
        button = {},
        toggle = {},
        slider = {},
    },
    search = {
        active = false,
        filter = "",
        anim = 37,
        anim_alpha = 0,
    },
    cache_buttons = {},
    key_binds = {},
    notifications = {},
    scroll = {},
    toggles = {},
    sliders = {},
    inputs = {},
    math = {
        lerp = function(delta, from, to)
            if delta > 1 then return to end
            if delta < 0 then return from end
        
            return from + (to - from) * delta
        end,
    },
    string = {
        normalize = function(text, size, maxwidth)
            local normalized = text
    
            while GoatAPI.Fonts.GetTextWidthSize(normalized, size) > maxwidth do
                normalized = string.sub(normalized, 2) 
            end
    
            return normalized
        end,

        normalize_reverse = function(text, size, maxwidth)
            local normalized = text
    
            while GoatAPI.Fonts.GetTextWidthSize(normalized, size) > maxwidth do
                normalized = normalized:sub(1, -2) 
            end
    
            return normalized
        end,
    },
    table = {
        includes = function(tab, el)
            for _, v in pairs(tab) do
                if el == v then
                    return true
                end
            end

            return false
        end,
    },
    vkCodes = {
        ['LBUTTON'] = 0x01,
        ['ENTER'] = 0x0D,
        ['0'] = 0x30,
        ['1'] = 0x31,
        ['2'] = 0x32,
        ['3'] = 0x33,
        ['4'] = 0x34,
        ['5'] = 0x35,
        ['6'] = 0x36,
        ['7'] = 0x37,
        ['8'] = 0x38,
        ['9'] = 0x39,
        ['A'] = 0x41,
        ['B'] = 0x42,
        ['C'] = 0x43,
        ['D'] = 0x44,
        ['E'] = 0x45,
        ['F'] = 0x46,
        ['G'] = 0x47,
        ['H'] = 0x48,
        ['I'] = 0x49,
        ['J'] = 0x4A,
        ['K'] = 0x4B,
        ['L'] = 0x4C,
        ['M'] = 0x4D,
        ['N'] = 0x4E,
        ['O'] = 0x4F,
        ['P'] = 0x50,
        ['Q'] = 0x51,
        ['R'] = 0x52,
        ['S'] = 0x53,
        ['T'] = 0x54,
        ['U'] = 0x55,
        ['V'] = 0x56,
        ['W'] = 0x57,
        ['X'] = 0x58,
        ['Y'] = 0x59,
        ['Z'] = 0x5A,
        [' '] = 0x20,
        ['_'] = 0xBD,
        ['CTRL'] = 0x11,
        ['F7'] = 0x76,
        ['BACKSPACE'] = 0x08
    },
    cache = {
        players = {},
    },
}

-- Math
function framework.math.ease_in_out(t)
    if t < 0.5 then
        return 2 * t * t
    else
        return -1 + (4 - 2 * t) * t
    end
end

function framework.math.smooth_lerp(delta, from, to)
    local progress = framework.math.ease_in_out(delta)
    return framework.math.lerp(progress, from, to)
end

function framework:disable_controls()
    DisableControlAction(0, 1, true)
    DisableControlAction(0, 2, true)
    DisableControlAction(0, 16, true)
    DisableControlAction(0, 17, true)
    DisableControlAction(0, 157, true)
    DisablePlayerFiring(PlayerId(), true)

    for v, _ in pairs(self.static_y) do
        self.static_y[v] = 0
    end
end

function framework:window()
    self.vars.wait_tick = true

    local r, g, b = table.unpack(self.colors.theme)
    self:disable_controls()

    self.search.anim = self.math.lerp(0.15, self.search.anim or 37, self.search.active and 200 or 37)

    local progress = self.search.anim or 37
    local _filtered_text = self.search.filter or ''
    local filtered_text = #self.search.filter > 0 and _filtered_text or 'Pesquisar'
    local normalize_progress
    local normalized_text = self.string.normalize(filtered_text, 16.0, math.floor(progress - 36))

    if not (self.search.active) then
        self.search.anim_alpha = self.math.lerp(self.search.active and 0.15 or 0.20, self.search.anim_alpha or 0, self.search.active and 255 or 0)
    elseif (progress >= 100) then
        self.search.anim_alpha = self.math.lerp(self.search.active and 0.15 or 0.20, self.search.anim_alpha or 0, self.search.active and 255 or 0)
    end

    GoatAPI.Drawing.DrawRect('window_tabs_area', self.x, self.y, 150, self.height, 16, 16, 16, 255, 5.0)
    GoatAPI.Drawing.DrawRect('window_tabs_area_v2', self.x + 145, self.y, 10, self.height, 16, 16, 16, 255, 0.0)
    GoatAPI.Drawing.DrawRect('window_sections_area_' .. self.vars.selected_tab, self.x + 150, self.y, self.width - 145, self.height, 16, 16, 16, 255, 5.0)
    GoatAPI.Drawing.DrawRect('window_separator_' .. self.vars.selected_tab, self.x, self.y + 60, self.width, 1, 25, 25, 25, 255, 0.0)
    GoatAPI.Drawing.DrawRect('window_separator_v2_' .. self.vars.selected_tab, self.x + 156, self.y + 60, 1, self.height - 60, 25, 25, 25, 255, 0.0)
    GoatAPI.Drawing.DrawText('window_main_text', 'GOAT MENU', self.x + (160 / 2), self.y + 18, 30.0, true, 220, 220, 220, 255)
    GoatAPI.Drawing.DrawRect('window_search_area_' .. self.vars.selected_tab, self.x + self.width - (progress + 8), self.y + 12, progress, 37, 25, 25, 25, 255, 5.0)
    GoatAPI.Drawing.DrawText('window_search_icon_area_' .. self.vars.selected_tab, '\xef\x80\x82', self.x + self.width - (progress - 5), self.y + 22, 16.0, true, r, g, b, 255, self.fonts.font_awesome)
    GoatAPI.Drawing.DrawText('window_search_filter_area_' .. self.vars.selected_tab, normalized_text, self.x + self.width - (progress - 24), self.y + 22, 16.0, false, r, g, b, math.ceil(self.search.anim_alpha))
    -- GoatAPI.Drawing.DrawImage('window_image_test', self.images.goatLogo, self.x + 5, self.y + self.height - 20, 55, 55, 255, 255, 255, 255)

    if (IsDisabledControlJustPressed(0, 24) and self:hovered(self.x + self.width - (progress + 8), self.y + 12, progress, 37)) then
        self.search.active = not self.search.active
    end

    if (self.search.active) then
        if GoatAPI.IsKeyPressed(self.vkCodes['ENTER']) then
            self.search.active = false
        end

        if GoatAPI.IsKeyPressed(self.vkCodes['BACKSPACE']) then
            local last_try = self.vars.cooldown["delete"] or 0

            if GetGameTimer() - last_try > 100 and self.search.filter ~= "" then
                self.search.filter = _filtered_text:sub(1, -2)
                self.vars.cooldown["delete"] = GetGameTimer()
            end
        end

        local block_keys = { ['CTRL'] = true, ['F7'] = true, ['BACKSPACE'] = true, ['LBUTTON'] = true, ['ENTER'] = true }

        for key, vkCode in pairs(self.vkCodes) do
            if not block_keys[key] then
                local last_try = self.vars.cooldown[vkCode] or 0

                if GetGameTimer() - last_try > 250 and GoatAPI.IsKeyPressed(vkCode) then
                    self.search.filter = _filtered_text .. string.lower(key)
                    self.vars.cooldown[vkCode] = GetGameTimer()
                end
            end
        end
    end

    GoatAPI.Drawing.SetCursor(true)
end

function framework:draw_subtab(subtabName)
    local active = self.vars.selected_subtab == subtabName
    local tr, tg, tb = table.unpack(active and self.colors.theme or { 63, 66, 81 })

    if not self.animations.subtab[subtabName] then
        self.animations.subtab[subtabName] = { tr, tg, tb }
    end

    self.animations.subtab[subtabName][1] = self.math.lerp(0.15, self.animations.subtab[subtabName][1], tr)
    self.animations.subtab[subtabName][2] = self.math.lerp(0.15, self.animations.subtab[subtabName][2], tg)
    self.animations.subtab[subtabName][3] = self.math.lerp(0.15, self.animations.subtab[subtabName][3], tb)
    
    local cr, cg, cb =
        math.ceil(self.animations.subtab[subtabName][1]),
        math.ceil(self.animations.subtab[subtabName][2]),
        math.ceil(self.animations.subtab[subtabName][3])

    local text_width = GoatAPI.Fonts.GetTextWidthSize(subtabName, 20.0)
    local rect_width = 70

    if (not self.vars["subtabs_x_" .. self.vars.selected_tab]) then
        self.vars["subtabs_x_" .. self.vars.selected_tab] = 0
    end

    if (active) then
        self.vars["subtabs_x_" .. self.vars.selected_tab] = self.math.lerp(0.15, self.vars["subtabs_x_" .. self.vars.selected_tab], self.static_y.subtabs)
    end

    if (self.static_y.subtabs == 0) then
        GoatAPI.Drawing.DrawRect('subtab_selected_rectangle_' .. self.vars.selected_tab, self.x + self.vars["subtabs_x_" .. self.vars.selected_tab] + 160, self.y + 12, rect_width, 37, 25, 25, 25, 255, 5.0)
    end

    GoatAPI.Drawing.DrawText('subtabs_text_' .. subtabName, subtabName, self.x + self.static_y.subtabs + 160 + rect_width / 2, self.y + 22, 15.0, true, cr, cg, cb, 255)

    if (not active and IsDisabledControlJustPressed(0, 24) and self:hovered(self.x + self.static_y.subtabs + 160, self.y + 12, rect_width, 37)) then
        self.vars.selected_subtab = subtabName
    end

    self.static_y.subtabs = self.static_y.subtabs + (rect_width * 1.1)
end

function framework:draw_tab(tabName, tabIcon, subtabs)
    local active = self.vars.selected_tab == tabName
    local tr, tg, tb = table.unpack(active and self.colors.theme or { 63, 66, 81 })

    if not self.animations.tab[tabName] then
        self.animations.tab[tabName] = { tr, tg, tb }
    end

    self.animations.tab[tabName][1] = self.math.lerp(0.15, self.animations.tab[tabName][1], tr)
    self.animations.tab[tabName][2] = self.math.lerp(0.15, self.animations.tab[tabName][2], tg)
    self.animations.tab[tabName][3] = self.math.lerp(0.15, self.animations.tab[tabName][3], tb)
    
    local cr, cg, cb =
        math.ceil(self.animations.tab[tabName][1]),
        math.ceil(self.animations.tab[tabName][2]),
        math.ceil(self.animations.tab[tabName][3])

    if (not self.vars.offset_y) then
        self.vars.offset_y = 0
    end

    if (active) then
        if (subtabs and subtabs[1] and (not self.vars.selected_subtab or not self.table.includes(subtabs, self.vars.selected_subtab))) then
            self.vars.selected_subtab = subtabs[1]
        end

        if (subtabs) then
            for _, subtabName in pairs(subtabs) do
                self:draw_subtab(subtabName)
            end
        end

        self.vars.offset_y = self.math.lerp(0.15, self.vars.offset_y, self.static_y.tabs)
    end

    if (self.static_y.tabs == 0) then
        GoatAPI.Drawing.DrawRect('tab_selected_rectangle', self.x + 7, self.y + self.static_y.tabs + self.vars.offset_y + 67, 145, 37, 25, 25, 25, 255, 3.0)
    end

    GoatAPI.Drawing.DrawText('tab_icon_rectangle_' .. tabName .. tostring(self.static_y.tabs), tabIcon, self.x + 16, self.y + self.static_y.tabs + 77, 18.0, false, cr, cg, cb, 255, self.fonts.font_awesome)
    GoatAPI.Drawing.DrawText('tab_text_rectangle_' .. tabName .. tostring(self.static_y.tabs), tabName, self.x + 46, self.y + self.static_y.tabs + 78, 16.0, false, cr, cg, cb, 255)

    if (not active and IsDisabledControlJustPressed(0, 24) and self:hovered(self.x + 4, self.y + 67 + self.static_y.tabs, 145, 37)) then
        self.vars.selected_tab = tabName
        if (subtabs and subtabs[1] and (not self.vars.selected_subtab or not self.table.includes(subtabs, self.vars.selected_subtab))) then
            self.vars.selected_subtab = subtabs[1]
        end
        self.vars.wait_tick = false
    end

    self.static_y.tabs = self.static_y.tabs + 48
end

function framework:draw_section(section_title, x, y, w, h)
    if (self.vars.wait_tick) then
        local stx = self.x + 161
        local sty = self.y + 66
    
        GoatAPI.Drawing.DrawRect('section_' .. section_title .. '_' .. self.vars.selected_tab, stx + x, sty + y, w, h, 25, 25, 25, 255, 5.0)
        GoatAPI.Drawing.DrawRect('section_v2_' .. section_title .. '_' .. self.vars.selected_tab, stx + x + 2, sty + y + 2, w - 4, h - 4, 20, 20, 20, 255, 5.0)
        GoatAPI.Drawing.DrawRect('section_v3_' .. section_title .. '_' .. self.vars.selected_tab, stx + x + 2, sty + y + 2, w - 4, 30, 18, 18, 18, 255, 5.0)
        GoatAPI.Drawing.DrawRect('section_v4_' .. section_title .. '_' .. self.vars.selected_tab, stx + x + 2, sty + y + 28, w - 4, 9, 18, 18, 18, 255, 0.0)
        GoatAPI.Drawing.DrawRect('section_v5_' .. section_title .. '_' .. self.vars.selected_tab, stx + x + 2, sty + y + 35, w - 4, 2, 25, 25, 25, 255, 0.0)
    
        GoatAPI.Drawing.DrawText('section_text_' .. section_title .. self.vars.selected_tab, section_title, stx + x + 8, sty + y + 9, 18.0, false, 220, 220, 220, 255)
    
        self.vars.active_groupbox = {
            tag = section_title .. "_" .. self.vars.selected_tab .. "_" .. self.vars.selected_subtab,
            x = stx + x,
            y = sty + y,
            width = w,
            height = h,
            static_y = 0,
        }
    end
end

function framework:end_section()
    local gb = self.vars.active_groupbox

    if (gb and self.vars.wait_tick) then
        if (self:hovered(gb.x, gb.y, gb.width, gb.height)) then
            local current_scroll = self.scroll[gb.tag] or 0
            local spacement = 25

            local stay = gb.static_y or 0

            local max_btns = math.floor((gb.height - 4) / spacement) - 1
            local max_btns_size = max_btns * spacement
            local calc = -spacement * ((stay / spacement) - max_btns)

            if IsDisabledControlPressed(1, 15) and current_scroll < 0.0 then
                self.scroll[gb.tag] = current_scroll + spacement
            elseif IsDisabledControlPressed(1, 14) and current_scroll > calc then
                self.scroll[gb.tag] = current_scroll - spacement
            end

            if stay <= (spacement * max_btns) and self.scroll[gb.tag] ~= 0 then
                self.scroll[gb.tag] = 0
            end
        end
    end

    self.vars.active_groupbox = {} 
end

-- Components
function framework:draw_button(text, callback)
    if (self.vars.wait_tick) then
        local gb = self.vars.active_groupbox
        if (not gb) then return end

        local scroll = self.scroll[gb.tag] or 0
        if (not ((gb.y + 34 + gb.static_y + scroll) < gb.y + 34) and not ((gb.y + 30 + gb.static_y + scroll + 30) > gb.y + gb.height)) then
            local hovered = self:hovered(gb.x + 8, gb.y + gb.static_y + scroll + 41, gb.width, 21)
            local tr, tg, tb = table.unpack(hovered and { 220, 220, 220 } or { 150, 150, 150 })
            local button_tag = gb.tag .. '_btn_' .. text

            if not self.search.active and not self.cache_buttons[button_tag] then
                self.cache_buttons[button_tag] = {
                    text = text,
                    cb = callback,
                    type = "button",
                }
            end

            if not self.animations.button[button_tag] then
                self.animations.button[button_tag] = { tr, tg, tb }
            end
        
            self.animations.button[button_tag][1] = self.math.lerp(0.15, self.animations.button[button_tag][1], tr)
            self.animations.button[button_tag][2] = self.math.lerp(0.15, self.animations.button[button_tag][2], tg)
            self.animations.button[button_tag][3] = self.math.lerp(0.15, self.animations.button[button_tag][3], tb)
            
            local cr, cg, cb =
                math.ceil(self.animations.button[button_tag][1]),
                math.ceil(self.animations.button[button_tag][2]),
                math.ceil(self.animations.button[button_tag][3])    

            local keybind_text = ""

            if self.key_binds[button_tag] then
                keybind_text = " [" .. string.upper(self.key_binds[button_tag].text) .. "]"
            end

            local draw_button_tag = gb.tag .. '_' .. tostring(gb.static_y + scroll)
            GoatAPI.Drawing.DrawText('button_text_' .. draw_button_tag, text .. keybind_text, gb.x + 8, gb.y + gb.static_y + scroll + 41, 17.0, false, cr, cg, cb, 255)

            if (callback and hovered and IsDisabledControlJustPressed(0, 24)) then
                CreateThread(callback)
            elseif (hovered and IsDisabledControlJustPressed(0, 25) and not self.key_binds.active) then
                self.key_binds.active = button_tag

                CreateThread(function()
                    self.key_binds[self.key_binds.active] = {
                        text = "...",
                        id = 999
                    }

                    while self.key_binds.active do
                        if IsDisabledControlJustPressed(0, 191) then
                            break
                        end

                        if IsDisabledControlJustPressed(0, 194) then
                            self.key_binds[self.key_binds.active] = nil
                            break
                        end

                        for key, vkCode in pairs(self.vkCodes) do
                            local last_try = self.vars.cooldown[vkCode] or 0

                            if GetGameTimer() - last_try > 250 and GoatAPI.IsKeyPressed(vkCode) then
                                self.key_binds[self.key_binds.active] = {
                                    text = string.lower(key),
                                    id = vkCode,
                                    cb = callback,
                                    text_name = text,
                                    type = "button"
                                }
                                self.key_binds.active = nil
                                self.vars.cooldown[vkCode] = GetGameTimer()
                            end
                        end

                        Wait(0)
                    end

                    if self.key_binds[self.key_binds.active] and self.key_binds[self.key_binds.active].text == "..." then
                        self.key_binds[self.key_binds.active] = nil
                    end

                    self.key_binds.active = nil
                end)
            end
        end

        gb.static_y = gb.static_y + 25
    end
end

function framework:draw_list_button(text, selected, callback)
    if (self.vars.wait_tick) then
        local gb = self.vars.active_groupbox
        if (not gb) then return end

        local scroll = self.scroll[gb.tag] or 0
        if (not ((gb.y + 34 + gb.static_y + scroll) < gb.y + 34) and not ((gb.y + 30 + gb.static_y + scroll + 30) > gb.y + gb.height)) then
            local hovered = self:hovered(gb.x + 8, gb.y + gb.static_y + scroll + 41, gb.width, 21)
            local tr, tg, tb = table.unpack(selected and self.colors.theme or (hovered and { 220, 220, 220 } or { 150, 150, 150 }))
            local button_tag = gb.tag .. '_btn_' .. text

            if not self.animations.button[button_tag] then
                self.animations.button[button_tag] = { tr, tg, tb }
            end
        
            self.animations.button[button_tag][1] = self.math.lerp(0.15, self.animations.button[button_tag][1], tr)
            self.animations.button[button_tag][2] = self.math.lerp(0.15, self.animations.button[button_tag][2], tg)
            self.animations.button[button_tag][3] = self.math.lerp(0.15, self.animations.button[button_tag][3], tb)
            
            local cr, cg, cb =
                math.ceil(self.animations.button[button_tag][1]),
                math.ceil(self.animations.button[button_tag][2]),
                math.ceil(self.animations.button[button_tag][3])    

            local draw_button_tag = gb.tag .. '_' .. tostring(gb.static_y + scroll)
            GoatAPI.Drawing.DrawText('button_text_' .. draw_button_tag, text, gb.x + 8, gb.y + gb.static_y + scroll + 41, 17.0, false, cr, cg, cb, 255)

            if (callback and hovered and IsDisabledControlJustPressed(0, 24)) then
                CreateThread(callback)
            end
        end

        gb.static_y = gb.static_y + 25
    end
end

function framework:draw_checkbox(text, identifier, callback)
    if (self.vars.wait_tick) then
        local gb = self.vars.active_groupbox
        if (not gb) then return end

        local scroll = self.scroll[gb.tag] or 0
        if (not ((gb.y + 34 + gb.static_y + scroll) < gb.y + 34) and not ((gb.y + 30 + gb.static_y + scroll + 30) > gb.y + gb.height)) then
            local hovered = self:hovered(gb.x + 8, gb.y + gb.static_y + scroll + 41, gb.width, 21)
            local active = self.toggles[identifier]
            local diff_x = active and 14 or 0
            local tr, tg, tb = table.unpack(hovered and { 220, 220, 220 } or { 150, 150, 150 })
            local cr1, cg1, cb1 = table.unpack(active and { 40, 40, 40 } or { 18, 18, 18 })
            local cr2, cg2, cb2 = table.unpack(active and { 240, 240, 240 } or { 120, 120, 120 })
            local button_tag = gb.tag .. '_check_' .. text .. '_' .. identifier

            if not self.search.active and not self.cache_buttons[button_tag] then
                self.cache_buttons[button_tag] = {
                    text = text,
                    id = identifier,
                    cb = callback,
                    type = "checkbox"
                }
            end
            
            if not self.animations.button[button_tag] then
                self.animations.button[button_tag] = { tr, tg, tb }
                self.animations.button[button_tag .. "_c1"] = { cr1, cg1, cb1 }
                self.animations.button[button_tag .. "_c2"] = { cr2, cg2, cb2 }
                self.animations.button[button_tag .. "anim"] = diff_x
            end
        
            self.animations.button[button_tag][1] = self.math.lerp(0.15, self.animations.button[button_tag][1], tr)
            self.animations.button[button_tag][2] = self.math.lerp(0.15, self.animations.button[button_tag][2], tg)
            self.animations.button[button_tag][3] = self.math.lerp(0.15, self.animations.button[button_tag][3], tb)

            self.animations.button[button_tag .. "_c1"][1] = self.math.lerp(0.15, self.animations.button[button_tag .. "_c1"][1], cr1)
            self.animations.button[button_tag .. "_c1"][2] = self.math.lerp(0.15, self.animations.button[button_tag .. "_c1"][2], cg1)
            self.animations.button[button_tag .. "_c1"][3] = self.math.lerp(0.15, self.animations.button[button_tag .. "_c1"][3], cb1)

            self.animations.button[button_tag .. "_c2"][1] = self.math.lerp(0.15, self.animations.button[button_tag .. "_c2"][1], cr2)
            self.animations.button[button_tag .. "_c2"][2] = self.math.lerp(0.15, self.animations.button[button_tag .. "_c2"][2], cg2)
            self.animations.button[button_tag .. "_c2"][3] = self.math.lerp(0.15, self.animations.button[button_tag .. "_c2"][3], cb2)

            self.animations.button[button_tag .. "anim"] = self.math.lerp(0.15, self.animations.button[button_tag .. "anim"], diff_x)
            
            local cr, cg, cb =
                math.ceil(self.animations.button[button_tag][1]),
                math.ceil(self.animations.button[button_tag][2]),
                math.ceil(self.animations.button[button_tag][3])    

            local v1_cr, v1_cg, v1_cb =
                math.ceil(self.animations.button[button_tag .. "_c1"][1]),
                math.ceil(self.animations.button[button_tag .. "_c1"][2]),
                math.ceil(self.animations.button[button_tag .. "_c1"][3])  
                
            local v2_cr, v2_cg, v2_cb =
                math.ceil(self.animations.button[button_tag .. "_c2"][1]),
                math.ceil(self.animations.button[button_tag .. "_c2"][2]),
                math.ceil(self.animations.button[button_tag .. "_c2"][3])  

            local keybind_text = ""

            if self.key_binds[button_tag] then
                keybind_text = " [" .. string.upper(self.key_binds[button_tag].text) .. "]"
            end

            local draw_button_tag = gb.tag .. '_' .. tostring(gb.static_y + scroll)

            GoatAPI.Drawing.DrawText('button_text_' .. draw_button_tag, text .. keybind_text, gb.x + 8, gb.y + gb.static_y + scroll + 41, 17.0, false, cr, cg, cb, 255)
            GoatAPI.Drawing.DrawRect('button_rect_v1_text_' .. draw_button_tag, gb.x + gb.width - 38, gb.y + gb.static_y + scroll + 45, 28, 10, v1_cr, v1_cg, v1_cb, 255, 5.0)
            GoatAPI.Drawing.DrawRect('button_rect_v2_text_' .. draw_button_tag, gb.x + gb.width - 38 + self.animations.button[button_tag .. "anim"], gb.y + gb.static_y + scroll + 43, 14, 14, v2_cr, v2_cg, v2_cb, 255, 35.0)

            if (hovered and IsDisabledControlJustPressed(0, 24)) then
                self.toggles[identifier] = not active
                if (callback) then
                    CreateThread(function()
                        callback(self.toggles[identifier])
                    end)
                end
            elseif (hovered and IsDisabledControlJustPressed(0, 25) and not self.key_binds.active) then
                self.key_binds.active = button_tag

                CreateThread(function()
                    self.key_binds[self.key_binds.active] = {
                        text = "...",
                        id = 999
                    }

                    while self.key_binds.active do
                        if IsDisabledControlJustPressed(0, 191) then
                            break
                        end

                        if IsDisabledControlJustPressed(0, 194) then
                            self.key_binds[self.key_binds.active] = nil
                            break
                        end

                        for key, vkCode in pairs(self.vkCodes) do
                            local last_try = self.vars.cooldown[vkCode] or 0

                            if GetGameTimer() - last_try > 250 and GoatAPI.IsKeyPressed(vkCode) then
                                self.key_binds[button_tag] = {
                                    text = string.lower(key),
                                    id = vkCode,
                                    cb = callback,
                                    identifier = identifier,
                                    text_name = text,
                                    type = "checkbox"
                                }
                                self.key_binds.active = nil
                                self.vars.cooldown[vkCode] = GetGameTimer()
                            end
                        end

                        Wait(0)
                    end

                    if self.key_binds[self.key_binds.active] and self.key_binds[self.key_binds.active].text == "..." then
                        self.key_binds[self.key_binds.active] = nil
                    end

                    self.key_binds.active = nil
                end)
            end
        end

        gb.static_y = gb.static_y + 25
    end
end

function framework:draw_slider(text, identifier, values, callback)
    if (self.vars.wait_tick) then
        local gb = self.vars.active_groupbox
        if (not gb) then return end

        local scroll = self.scroll[gb.tag] or 0
        if (not ((gb.y + 34 + gb.static_y + scroll) < gb.y + 34) and not ((gb.y + 30 + gb.static_y + scroll + 30) > gb.y + gb.height)) then
            local button_tag = gb.tag .. '_btn_' .. text
            local hovered = self:hovered(gb.x + 8, gb.y + gb.static_y + scroll + 41, gb.width, 21)
            local value = self.sliders[identifier] or values.start
            local activeMoving = self.animations.slider[button_tag .. '_active'] or false

            if not self.search.active and not self.cache_buttons[button_tag] then
                self.cache_buttons[button_tag] = {
                    text = text,
                    id = identifier,
                    values = values,
                    on_change = callback,
                    type = "slider"
                }
            end

            local tr, tg, tb = table.unpack(hovered and { 220, 220, 220 } or { 150, 150, 150 })

            local slider_width = 90
            local filled_width = math.floor(slider_width * ((value - values.min) / (values.max - values.min)))
            local cur_anim = self.animations.slider[identifier .. "-anim"] or 0
            self.animations.slider[identifier .. "-anim"] = self.math.lerp(0.15, cur_anim, filled_width)

            if not self.animations.slider[button_tag] then
                self.animations.slider[button_tag] = { tr, tg, tb }
            end
        
            self.animations.slider[button_tag][1] = self.math.lerp(0.15, self.animations.slider[button_tag][1], tr)
            self.animations.slider[button_tag][2] = self.math.lerp(0.15, self.animations.slider[button_tag][2], tg)
            self.animations.slider[button_tag][3] = self.math.lerp(0.15, self.animations.slider[button_tag][3], tb)
            
            local cr, cg, cb =
                math.ceil(self.animations.slider[button_tag][1]),
                math.ceil(self.animations.slider[button_tag][2]),
                math.ceil(self.animations.slider[button_tag][3])    

            local draw_button_tag = gb.tag .. '_' .. tostring(gb.static_y + scroll)
            GoatAPI.Drawing.DrawText('button_text_' .. draw_button_tag, text, gb.x + 8, gb.y + gb.static_y + scroll + 41, 17.0, false, cr, cg, cb, 255)
            GoatAPI.Drawing.DrawRect('button_rect_value_slider_' .. draw_button_tag, gb.x + gb.width - 43, gb.y + gb.static_y + scroll + 43, 35, 16, 40, 40, 40, 255, 3.0)
            GoatAPI.Drawing.DrawText('button_text_value_' .. draw_button_tag, tostring(value), gb.x + gb.width - 40, gb.y + gb.static_y + scroll + 42, 16.0, false, activeMoving and cr or 150, activeMoving and cg or 150, activeMoving and cb or 150, 255)
            GoatAPI.Drawing.DrawRect('button_rect_slider_' .. draw_button_tag, gb.x + gb.width - 93 - 50, gb.y + gb.static_y + scroll + 48, slider_width, 5, 40, 40, 40, 255, 8.0)
            GoatAPI.Drawing.DrawRect('button_rect_slider_v2_' .. draw_button_tag, gb.x + gb.width - 93 - 50, gb.y + gb.static_y + scroll + 48, cur_anim, 5, 240, 240, 240, 255, 8.0)
            GoatAPI.Drawing.DrawRect('button_rect_slider_v3_' .. draw_button_tag, gb.x + gb.width - 93 - 52 + cur_anim, gb.y + gb.static_y + scroll + 44, 13, 13, 240, 240, 240, 255, 90.0)

            if (hovered and IsDisabledControlPressed(0, 24)) then
                self.animations.slider[button_tag .. '_active'] = true

                local mx, my = GetNuiCursorPosition()
                local relativeX = math.min(math.max(mx - (gb.x + (gb.width - 93 - 50)), 0), slider_width)
                local percentage = relativeX / slider_width

                self.sliders[identifier] = math.floor(values.min + (values.max - values.min) * percentage)

                if (callback) then
                    CreateThread(function()
                        callback(self.sliders[identifier])
                    end)
                end
            elseif (self.animations.slider[button_tag .. '_active']) then
                self.animations.slider[button_tag .. '_active'] = false
            end
        end

        gb.static_y = gb.static_y + 25
    end
end

function framework:draw_input(text, identifier)
    if (self.vars.wait_tick) then
        local gb = self.vars.active_groupbox
        if (not gb) then return end

        local scroll = self.scroll[gb.tag] or 0
        if (not ((gb.y + 34 + gb.static_y + scroll) < gb.y + 34) and not ((gb.y + 30 + gb.static_y + scroll + 30) > gb.y + gb.height)) then
            if not self.inputs[identifier] then
                self.inputs[identifier] = ''
            end
            
            local hovered = self:hovered(gb.x + gb.width - 128, gb.y + gb.static_y + scroll + 41, 120, 18)
            local tr, tg, tb = table.unpack(hovered and { 220, 220, 220 } or { 150, 150, 150 })
            local button_tag = gb.tag .. '_btn_' .. text
            local value = self.inputs[identifier] or ''
            local normalized_value = self.string.normalize(value, 17.0, 120)
            local typing = self.inputs.active == identifier

            if not self.search.active and not self.cache_buttons[button_tag] then
                self.cache_buttons[button_tag] = {
                    text = text,
                    id = identifier,
                    type = "input"
                }
            end

            if not self.animations.button[button_tag] then
                self.animations.button[button_tag] = { tr, tg, tb }
            end
        
            self.animations.button[button_tag][1] = self.math.lerp(0.15, self.animations.button[button_tag][1], tr)
            self.animations.button[button_tag][2] = self.math.lerp(0.15, self.animations.button[button_tag][2], tg)
            self.animations.button[button_tag][3] = self.math.lerp(0.15, self.animations.button[button_tag][3], tb)
            
            local cr, cg, cb =
                math.ceil(self.animations.button[button_tag][1]),
                math.ceil(self.animations.button[button_tag][2]),
                math.ceil(self.animations.button[button_tag][3])    

            local draw_button_tag = gb.tag .. '_' .. tostring(gb.static_y + scroll)
            GoatAPI.Drawing.DrawText('button_text_' .. draw_button_tag, text, gb.x + 8, gb.y + gb.static_y + scroll + 41, 17.0, false, cr, cg, cb, 255)
            GoatAPI.Drawing.DrawRect('rect_input_' .. draw_button_tag, gb.x + gb.width - 128, gb.y + gb.static_y + scroll + 41, 120, 18, 16, 16, 16, 255, 5.0)
            GoatAPI.Drawing.DrawText('input_text_' .. draw_button_tag, normalized_value, gb.x + gb.width - 125, gb.y + gb.static_y + scroll + 40, 17.0, false, typing and cr or 150, typing and cg or 150, typing and cb or 150, 255)
            
            if (typing) then
                local text_width = GoatAPI.Fonts.GetTextWidthSize(normalized_value, 17.0)
                GoatAPI.Drawing.DrawRect('input_line_' .. draw_button_tag, gb.x + gb.width + text_width - 123, gb.y + gb.static_y + scroll + 43, 1, 14, 180, 180, 180, 255, 5.0)
            end

            if (hovered and IsDisabledControlJustPressed(0, 24) and not self.inputs.active) then
                self.inputs.active = identifier

                CreateThread(function()
                    if (not self.vars.cooldown) then
                        self.vars.cooldown = {}
                    end

                    while (self.inputs.active == identifier and self.show_menu and self.render) do
                        if GoatAPI.IsKeyPressed(self.vkCodes['ENTER']) then
                            break
                        end

                        if GoatAPI.IsKeyPressed(self.vkCodes['BACKSPACE']) then
                            local last_try = self.vars.cooldown["delete"] or 0
        
                            if GetGameTimer() - last_try > 100 then
                                self.inputs[identifier] = self.inputs[identifier]:sub(1, -2)
                                self.vars.cooldown["delete"] = GetGameTimer()
                            end
                        end

                        local block_vk_keys = {
                            ['CTRL'] = true,
                            ['F7'] = true,
                            ['BACKSPACE'] = true,
                            ['LBUTTON'] = true,
                            ['ENTER'] = true,
                        }

                        for key, vkCode in pairs(self.vkCodes) do
                            if not block_vk_keys[key] then
                                local last_try = self.vars.cooldown[vkCode] or 0

                                if GetGameTimer() - last_try > 250 and GoatAPI.IsKeyPressed(vkCode) then
                                    self.inputs[identifier] = self.inputs[identifier] .. string.lower(key)
                                    self.vars.cooldown[vkCode] = GetGameTimer()
                                end
                            end
                        end

                        Wait(0)
                    end

                    self.inputs.active = nil
                end)
            end
        end

        gb.static_y = gb.static_y + 25
    end
end

-- Notify
function framework:notify(text)
    local sW = GetActiveScreenResolution()

    table.insert(self.notifications, {
        time = GetGameTimer(),
        text = text,
        x = sW + 420,
        anim_time = 0.15,
        id = tostring(math.random(1000000, 9999999))
    })
end

-- Utils
function framework:hovered(x, y, w, h)
    local cursorX, cursorY = GetNuiCursorPosition()

    if (cursorX >= x and cursorX <= x + w and cursorY >= y and cursorY <= y + h) then
        return true
    end

    return false
end

CreateThread(function()
    while (framework.render) do
        local v1 = GetEntityCoords(PlayerPedId())

        local players = {}
        for _, player in pairs(GetActivePlayers()) do table.insert(players, player) end
    
        table.sort(players, function(a, b)
            return #(v1 - GetEntityCoords(GetPlayerPed(a))) < #(v1 - GetEntityCoords(GetPlayerPed(b)))
        end)

        local vehicles = {}
        for _, vehicle in pairs(GetGamePool('CVehicle')) do table.insert(vehicles, vehicle) end
    
        table.sort(vehicles, function(a, b)
            return #(v1 - GetEntityCoords(a)) < #(v1 - GetEntityCoords(b))
        end)
        
        framework.cache.players = players
        framework.cache.vehicles = vehicles

        Wait(1500)
    end
end)

CreateThread(function()
    while (framework.render) do
        local sW, sH = GetActiveScreenResolution()

        for _, bindInfo in pairs(framework.key_binds) do
            if type(bindInfo) == "table" and _ ~= "menu" then
                local last_try = framework.vars.cooldown[bindInfo.id] or 0

                if GetGameTimer() - last_try > 250 and GoatAPI.IsKeyPressed(bindInfo.id) and bindInfo.type then
                    if bindInfo.type == "button" then
                        if bindInfo.cb and type(bindInfo.cb) == "function" then CreateThread(bindInfo.cb) end
                    else
                        framework.toggles[bindInfo.identifier] = not framework.toggles[bindInfo.identifier]
                        if bindInfo.cb and type(bindInfo.cb) == "function" then
                            CreateThread(function()
                                bindInfo.cb(framework.toggles[bindInfo.identifier])
                            end)
                        end
                    end

                    framework.vars.cooldown[bindInfo.id] = GetGameTimer()
                end
            end
        end

        if (framework.show_menu) then
            if (IsDisabledControlJustPressed(0, 24) and framework:hovered(framework.x, framework.y, framework.width, 40)) then
                local cursorX, cursorY = GetNuiCursorPosition()
            
                framework.drag.is_dragging = true
                framework.drag.offset_x = cursorX - framework.x
                framework.drag.offset_y = cursorY - framework.y
            end
        
            if (framework.drag.is_dragging) then
                local cursorX, cursorY = GetNuiCursorPosition()
                
                framework.x = cursorX - framework.drag.offset_x
                framework.y = cursorY - framework.drag.offset_y
            end
        end

        if (IsDisabledControlJustReleased(0, 24) or not framework.show_menu) then
            framework.drag.is_dragging = false
        end

        local cur_time = GetGameTimer()
        for i, notify in pairs(framework.notifications) do
            if (cur_time - notify.time > 3000) then
                notify.x = framework.math.smooth_lerp(0.16, notify.x, sW + 100)

                if (notify.x >= (sW + 90)) then
                    table.remove(framework.notifications, i)
                end
            else
                notify.x = framework.math.smooth_lerp(0.16, notify.x, sW - 310)
            end

            local add_y = (i - 1) * 85
            GoatAPI.Drawing.DrawRect('notify_rect_' .. notify.id, notify.x, 10 + add_y, 300, 75, 22, 22, 22, 240, 5.0)
            GoatAPI.Drawing.DrawRect('notify_rect_v2_' .. notify.id, notify.x + 13, 24 + add_y, 45, 45, 10, 10, 10, 255, 5.0)
            GoatAPI.Drawing.DrawText('notify_icon_' .. notify.id, '\xef\x81\xb1', notify.x + 25, 35 + add_y, 22.0, false, 255, 255, 255, 255, framework.fonts.font_awesome)
            GoatAPI.Drawing.DrawText('notify_text_' .. notify.id, 'Aviso', notify.x + 66, 28 + add_y, 18.0, false, 255, 255, 255, 255)
            GoatAPI.Drawing.DrawText('notify_text_v2_' .. notify.id, notify.text, notify.x + 66, 44 + add_y, 18.0, false, 180, 180, 180, 255)
        end

        Wait(0)
    end
end)

CreateThread(function()
    while (framework.render) do
        if (IsDisabledControlJustPressed(0, framework.vars.keybind)) then
            framework.show_menu = not framework.show_menu
        end

        if (framework.show_menu) then
            framework.draw = true

            framework:window()
            framework:draw_tab("Jogador", "\xef\x94\x84", { "Self", "Players" })
            framework:draw_tab("Veiculos", "\xef\x86\xb9", { "Radar" })

            if (framework.search.active and (framework.search.filter ~= "" and framework.search.filter ~= "Pesquisar")) then
                local filter_text = framework.search.filter or ""

                framework:draw_section("Resultados", 0, 0, 280, 467)
        
                for _, btn in pairs(framework.cache_buttons) do
                    if btn.type and string.find(string.lower(btn.text), string.lower(filter_text)) then
                        if btn.type == "button" then
                            framework:draw_button(btn.text, btn.cb)
                        elseif btn.type == "checkbox" then
                            framework:draw_checkbox(btn.text, btn.id, btn.cb or function() end)
                        elseif btn.type == "slider" then
                            framework:draw_slider(btn.text, btn.id, btn.values, btn.on_change)
                        elseif btn.type == "input" then
                            framework:draw_input(btn.text, btn.id)
                        end
                    end
                end

                framework:end_section()
            else
                if (framework.vars.selected_tab == "Jogador") then
                    if (framework.vars.selected_subtab == "Self") then
                        framework:draw_section("Globals", 0, 0, 280, 200)
    
                        framework:draw_button("Reviver", function()
                            local x, y, z = table.unpack(GetEntityCoords(PlayerPedId()))
                            NetworkResurrectLocalPlayer(x, y, z, GetEntityHeading(PlayerPedId()), 0, 0)
                            framework:notify("Revivido com sucesso!")
                        end)
                        framework:draw_button("NC", function()
                            ExecuteCommand("nc")
                        end)
                        framework:draw_checkbox("Godmode", "godMode", function(v)
                            while framework.toggles["godMode"] do -- Enquanto está ativado
                                SetEntityOnlyDamagedByRelationshipGroup(PlayerPedId(), true, tostring(math.random(1000000, 9999999)))
                                Wait(0)
                            end
    
                            -- Desligou
                            SetEntityOnlyDamagedByRelationshipGroup(PlayerPedId(), false)
                        end)
                        framework:draw_slider("Colete", "coleteSlider", { min = 0, max = 100, start = 0 }, function(v)
                            SetPedArmour(PlayerPedId(), v)
                        end)
                        framework:draw_input("Arma", "weaponSpawn")
                        framework:draw_button("Spawnar Arma", function()
                            local weapon = framework.inputs["weaponSpawn"]
                            if (weapon and IsWeaponValid(weapon)) then
                                GiveWeaponToPed(PlayerPedId(), weapon, 100, false, false)
                                framework:notify("Arma spawnada sucesso!")
                            else
                                framework:notify("Arma inválida.")
                            end
                        end)
    
                        framework:end_section()
                    else
                        framework:draw_section("Players", 0, 0, 280, 300)
                        
                        framework:draw_input("Pesquisar", "playerFilter")
    
                        local self_cds = GetEntityCoords(PlayerPedId())
                        local filter = framework.inputs["playerFilter"] or ""
    
                        for _, player in pairs(framework.cache.players) do
                            local pname = GetPlayerName(player)
    
                            if (string.find(string.lower(pname), string.lower(filter)) or #filter == 0) then
                                local ped = GetPlayerPed(player)
                                local dist = #(self_cds - GetEntityCoords(ped))
                                local selected = framework.vars.selected_player == player
                                local ptext = string.format("%.0f", dist) .. "m"
                                
                                if player == PlayerId() then
                                    ptext = "[Você]"
                                end
    
                                framework:draw_list_button(pname .. " - " .. ptext, selected, function()
                                    if (selected) then
                                        framework.vars.selected_player = nil
                                    else
                                        framework.vars.selected_player = player
                                    end
                                end)
                            end
                        end
                        
                        framework:end_section()
    
                        framework:draw_section("Opções", 288, 0, 280, 95)
    
                        framework:draw_button("Copiar Roupa", function()
                            local selected_ped = GetPlayerPed(framework.vars.selected_player)
    
                            if (DoesEntityExist(selected_ped)) then
                                ClonePedToTarget(selected_ped, PlayerPedId())
                            end
                        end)
    
                        framework:draw_button("Teleportar no Player", function()
                            local selected_ped = GetPlayerPed(framework.vars.selected_player)
    
                            if (DoesEntityExist(selected_ped)) then
                                SetEntityCoordsNoOffset(PlayerPedId(), GetEntityCoords(selected_ped))
                            end
                        end)
    
                        framework:end_section()
                    end
                elseif (framework.vars.selected_tab == "Veiculos") then
                    if (framework.vars.selected_subtab == "Radar") then
                        framework:draw_section("Veiculos", 0, 0, 280, 300)
                        
                        framework:draw_input("Pesquisar", "vehiclesFilter")
    
                        local self_cds = GetEntityCoords(PlayerPedId())
                        local filter = framework.inputs["vehiclesFilter"] or ""
    
                        for _, veh in pairs(framework.cache.vehicles) do
                            local vname = GetDisplayNameFromVehicleModel(GetEntityModel(veh))
    
                            if (vname ~= "CARNOTFOUND" and (string.find(string.lower(vname), string.lower(filter)) or #filter == 0)) then
                                local dist = #(self_cds - GetEntityCoords(veh))
                                local selected = framework.vars.selected_vehicle == veh
                                local vtext = string.format("%.0f", dist) .. "m"
    
                                framework:draw_list_button(vname .. " - " .. vtext, selected, function()
                                    if (selected) then
                                        framework.vars.selected_vehicle = nil
                                    else
                                        framework.vars.selected_vehicle = veh
                                    end
                                end)
                            end
                        end
    
                        framework:end_section()
    
                        framework:draw_section("Opções", 288, 0, 280, 70)
    
                        framework:draw_button("Teleportar no Veiculo", function()
                            if (DoesEntityExist(framework.vars.selected_vehicle) and IsVehicleSeatFree(framework.vars.selected_vehicle, -1)) then
                                SetPedIntoVehicle(PlayerPedId(), framework.vars.selected_vehicle, -1)
                            end
                        end)
    
                        framework:end_section()
                    end
                end
            end
        elseif (framework.draw) then
            GoatAPI.Drawing.SetCursor(false)
            framework.draw = false
        end

        Wait(0)
    end
end)