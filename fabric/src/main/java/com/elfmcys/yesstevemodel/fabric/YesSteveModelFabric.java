package com.yesstevemodel.fabric; // <- GANTI INI

import com.yesstevemodel.YesSteveModel; // <- GANTI INI JUGA
import net.fabricmc.api.ModInitializer;
import net.fabricmc.fabric.api.networking.v1.EntityTrackingEvents;
import net.minecraft.server.level.ServerPlayer;
import com.yesstevemodel.capability.ModelInfoCapability; // <- GANTI
import com.yesstevemodel.network.NetworkHandler; // <- GANTI

public final class YesSteveModelFabric implements ModInitializer {
    @Override
    public void onInitialize() {
        YesSteveModel.init();
        EntityTrackingEvents.START_TRACKING.register((trackedEntity, player) -> {
            if (!YesSteveModel.isAvailable()) return;
            if (trackedEntity instanceof ServerPlayer serverPlayer) {
                ModelInfoCapability.get(serverPlayer).ifPresent(c -> {
                    c.createSyncMessage(serverPlayer, false).ifPresent(m -> NetworkHandler.sendToClientPlayer(m, player));
                });
            }
        });
    }
}
