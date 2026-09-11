<?php

use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return view('welcome');
});

Route::get('/health', function () {
    // Vérifier la connexion à la base de données
    try {
        DB::connection()->getPdo();
        $dbStatus = 'ok';
    } catch (Throwable $e) {
        $dbStatus = 'error';
    }

    $status = $dbStatus === 'ok' ? 'ok' : 'degraded';
    $httpCode = $status === 'ok' ? 200 : 503;

    return response()->json([
        'status' => $status,
        'database' => $dbStatus,
        'version' => config('app.version', '1.0.0'),
    ], $httpCode);
});
